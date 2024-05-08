To Start Jenkins you need to have java installed.


## Jenkins CLI
If we want to talk with jenkins through the CLI we need to have java installed on our machine and a token to be able to access the jenkins server.

To get the token we need to go to the jenkins web page and click on the user icon on the top right corner and then click on the "Configure" button.
Then you will see option to create a Token.
Make sure you change the name before the token.
```
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth oran:11d49a4f4a700f35cd00e93b7fc2145654
```
You will see a bunch of command that you can use.

Another way is to Interact with Jenkins over SSH server share the public-ssh key and then to go to user setting and add to a the public key to the user.
To Check if it worked you can use this commands
```
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth oran:11d49a4f4a700f35cd00e93b7fc214565
ssh -i /home/{user}/.ssh/jenkins_key -l {user} -p 8022 jenkins-server help

```