$LOAD_PATH.unshift '../../lib/rb/lib'

require 'thrift/transport/ttransport'
require 'thrift/protocol/tbinaryprotocol'
require 'thrift/protocol/c/tfastbinaryprotocol'

require 'benchmark'
require 'rubygems'
require 'set'
require 'pp'

require 'ruby-debug'
require 'ruby-prof'

require 'test_helper'


transport = TMemoryBuffer.new
ruby_binary_protocol = TBinaryProtocol.new(transport)
c_fast_binary_protocol = TFastBinaryProtocol.new(transport)


ooe = ThriftStructs::OneOfEach.new
ooe.im_true   = true
ooe.im_false  = false
ooe.a_bite    = -42
ooe.integer16 = 27000
ooe.integer32 = 1<<24
ooe.integer64 = 6000 * 1000 * 1000
ooe.double_precision = Math::PI
ooe.some_characters  = "Debug THIS!"
ooe.zomg_unicode     = "\xd7\n\a\t"

n1 = ThriftStructs::Nested1.new
n1.a_list = []
n1.a_list << ooe << ooe << ooe << ooe
n1.i32_map = {}
n1.i32_map[1234] = ooe
n1.i32_map[46345] = ooe
n1.i32_map[-34264] = ooe
n1.i64_map = {}
n1.i64_map[43534986783945] = ooe
n1.i64_map[-32434639875122] = ooe
n1.dbl_map = {}
n1.dbl_map[324.65469834] = ooe
n1.dbl_map[-9458672340.4986798345112] = ooe
n1.str_map = {}
n1.str_map['sdoperuix'] = ooe
n1.str_map['pwoerxclmn'] = ooe

n2 = ThriftStructs::Nested2.new
n2.a_list = []
n2.a_list << n1 << n1 << n1 << n1 << n1
n2.i32_map = {}
n2.i32_map[398345] = n1
n2.i32_map[-2345] = n1
n2.i32_map[12312] = n1
n2.i64_map = {}
n2.i64_map[2349843765934] = n1
n2.i64_map[-123234985495] = n1
n2.i64_map[0] = n1
n2.dbl_map = {}
n2.dbl_map[23345345.38927834] = n1
n2.dbl_map[-1232349.5489345] = n1
n2.dbl_map[-234984574.23498725] = n1
n2.str_map = {}
n2.str_map[''] = n1
n2.str_map['sdflkertpioux'] = n1
n2.str_map['sdfwepwdcjpoi'] = n1

n3 = ThriftStructs::Nested3.new
n3.a_list = []
n3.a_list << n2 << n2 << n2 << n2 << n2
n3.i32_map = {}
n3.i32_map[398345] = n2
n3.i32_map[-2345] = n2
n3.i32_map[12312] = n2
n3.i64_map = {}
n3.i64_map[2349843765934] = n2
n3.i64_map[-123234985495] = n2
n3.i64_map[0] = n2
n3.dbl_map = {}
n3.dbl_map[23345345.38927834] = n2
n3.dbl_map[-1232349.5489345] = n2
n3.dbl_map[-234984574.23498725] = n2
n3.str_map = {}
n3.str_map[''] = n2
n3.str_map['sdflkertpioux'] = n2
n3.str_map['sdfwepwdcjpoi'] = n2

n4 = ThriftStructs::Nested4.new
n4.a_list = []
n4.a_list << n3
n4.i32_map = {}
n4.i32_map[-2345] = n3
n4.i64_map = {}
n4.i64_map[2349843765934] = n3
n4.dbl_map = {}
n4.dbl_map[-1232349.5489345] = n3
n4.str_map = {}
n4.str_map[''] = n3


# prof = RubyProf.profile do
#   n4.write(c_fast_binary_protocol)
#   ThriftStructs::Nested4.new.read(c_fast_binary_protocol)
# end
# 
# printer = RubyProf::GraphHtmlPrinter.new(prof)
# printer.print(STDOUT, :min_percent=>0)

Benchmark.bmbm do |x|
  x.report("ruby") do
    n4.write(ruby_binary_protocol)
    ThriftStructs::Nested4.new.read(ruby_binary_protocol)
  end
  x.report("c") do
    n4.write(c_fast_binary_protocol)
    ThriftStructs::Nested4.new.read(c_fast_binary_protocol)
  end
end