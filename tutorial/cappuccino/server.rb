#!/usr/bin/env ruby

$:.push('../gen-rb')
$:.unshift '../../lib/rb/lib'

require 'rubygems'
require 'sinatra'
require 'thrift'
require 'base64'

require 'calculator'
require 'shared_types'

class CalculatorHandler
  def initialize()
    @log = {}
  end

  def ping()
    puts "ping()"
  end

  def add(n1, n2)
    print "add(", n1, ",", n2, ")\n"
    return n1 + n2
  end

  def calculate(logid, work)
    print "calculate(", logid, ", {", work.op, ",", work.num1, ",", work.num2,"})\n"
    if work.op == Operation::ADD
      val = work.num1 + work.num2
    elsif work.op == Operation::SUBTRACT
      val = work.num1 - work.num2
    elsif work.op == Operation::MULTIPLY
      val = work.num1 * work.num2
    elsif work.op == Operation::DIVIDE
      if work.num2 == 0
        x = InvalidOperation.new()
        x.what = work.op
        x.why = "Cannot divide by 0"
        raise x
      end
      val = work.num1 / work.num2
    else
      x = InvalidOperation.new()
      x.what = work.op
      x.why = "Invalid operation"
      raise x
    end

    entry = SharedStruct.new()
    entry.key = logid
    entry.value = "#{val}"
    @log[logid] = entry

    return val

  end

  def getStruct(key)
    print "getStruct(", key, ")\n"
    return @log[key]
  end

  def zip()
    print "zip\n"
  end

end

def urlsafe_base64_decode(str)
  str.gsub!(/\-/, '+')
  str.gsub!(/_/, '/')
  
  Base64.decode64(str)
end

def urlsafe_base64_encode(str)
  str = Base64.encode64(str)
  str.gsub!(/\+/, '-')
  str.gsub!(/\//, '_')
  
  return str
end

post '/thrift' do
  content_type "application/x-thrift"
  input_buffer = request.env["rack.input"].read
  output_buffer = StringIO.new
  
  if params[:base64].eql?('true')
    # Thrift on Cappuccino will always encode things in Base64, and send
    # base64=true on the URL
    input_buffer = urlsafe_base64_decode(input_buffer)
  end
  
  handler = CalculatorHandler.new()
  processor = Calculator::Processor.new(handler)
  
  transport = Thrift::IOStreamTransport.new StringIO.new(input_buffer), output_buffer
  protocol_factory = Thrift::BinaryProtocolFactory.new()
  protocol = protocol_factory.get_protocol transport

  processor.process protocol, protocol

  output_buffer_string = nil
  
  if params[:base64].eql?('true')
    output_buffer_string = urlsafe_base64_encode(output_buffer.string)
  else
    output_buffer_string = output_buffer.string
  end
end

get '/' do
  redirect '/index.html'
end

