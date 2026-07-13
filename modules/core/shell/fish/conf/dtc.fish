devtunnel create $argv[1]
devtunnel port create $argv[1] -p $argv[2]
devtunnel access create $argv[1] -p $argv[2] --anonymous
devtunnel host $argv[1]
