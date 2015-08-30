request = require('request');

#TODO: rate limit messages to a given number

module.exports = {
  send: (opt,cb)->
    if(!opt?)
      opt={}
    if(!cb)
      cb=(err,id)->
        if(err)
          console.log('SMS API:',err)
    if(!opt.user || !opt.pass || !opt.sender || !opt.dest || !opt.msg)
      return cb("Missing user/pass/sender/dest/msg");
    api = opt.api || 'https://fast.smssolution.net.in/SendSMS/sendmsg.php'
    request.post({url: api, form: {
        uname: opt.user
        pass: opt.pass
        send: opt.sender
        dest: opt.dest
        msg: opt.msg
      }}, (err,resp)->
        if(err)
          return cb(err);
        if(regex = /0x\d+/.exec(resp.body))
          return cb("API Error code #"+regex[0]);
        return cb(null,resp.body);
    );
}


# Error Description
# 0x200 Invalid Username or Password
# 0x201 Account suspended due to one of several defined reasons
# 0x202 Invalid Source Address/Sender ID. As per GSM standard, the sender ID should be within 11 characters
# 0x203 Message length exceeded (more than 160 characters) if concat is set to 0
# 0x204 Message length exceeded (more than 459 characters) in concat is set to 1
# 0x205 DRL URL is not set
# 0x206 Only the subscribed service type can be accessed - make sure of the service type you are trying to connect with
# 0x207 Invalid Source IP  -   kindly check if the IP is responding
# 0x208 Account deactivated/expired
# 0x209 Invalid message length (less than 160 characters) if concat is set to 1
# 0x210 Invalid Parameter values
# 0x211 Invalid Message Length (more than 280 characters)
# 0x212 Invalid Message Length
# 0x213 Invalid Destination Number