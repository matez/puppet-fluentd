# This file is use for the beaker tests.

# basic installation
include '::fluentd'

# install a gem plugin
::fluentd::plugin { 'fluent-plugin-elasticsearch':
  type    => 'gem',
  require => Class['::fluentd']
}


::fluentd::source { 'test':
  priority => 10,
  config   => {
    'tag'    => 'test.foo',
    'type'   => 'tail',
    'path'   => '/tmp/log.log',
    'format' => 'syslog'
  }
}

::fluentd::filter { 'test':
  priority => 20,
  pattern  => 'test.*',
  config   => {
    'type'          => 'record_transformer',
    'auto_typecast' => 'yes',
    'enable_ruby'   => 'yes',
    'record' => {
      'foo' => 'foo_value',
      'bar' => 'bar_value',
      'baz' => 'baz_value',
      'omg' => 'omg_value'
    }
  }
}

::fluentd::match { 'test':
  priority => 30,
  pattern  => 'test.*',
  config   => {
    'type' => 'forward',
    'server' => {
      'name'   => 'localhost',
      'host'   => 'localhost',
      'weight' => 60
    },
    'secondary' => {
      'type' => 'file',
      'path' => '/tmp/fail.log'
    }
  }
}