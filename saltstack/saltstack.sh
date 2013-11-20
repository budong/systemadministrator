一：更改配置什么的，先测试啊
salt '49' state.highstate test=True
二：执行命令
salt '49' cmd.run "service vsftpd restart"
salt '*' disk.usage
salt '*' test.ping
三：认证 Minion Keys
1，输入salt-key -L 列出所以没有认证，认证过，拒绝认证的证书
2，你应该可以看到一个没有认证的证书1st-Salt-Minion（或者你自己选择的minion）
3,认证这个证书使用 sudo salt-key -a 1st-salt-minion
