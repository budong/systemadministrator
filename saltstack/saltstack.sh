一：更改配置什么的，先测试啊
salt '49' state.highstate test=True
二：执行命令
salt '49' cmd.run "service vsftpd restart"
salt '*' disk.usage
salt '*' test.ping
