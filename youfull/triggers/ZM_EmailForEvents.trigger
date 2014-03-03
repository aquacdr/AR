trigger ZM_EmailForEvents on Event (after insert) {

Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

for (Event new_event: Trigger.new) {
Contact c = [select Email from Contact where Id =:new_event.WhoId and Email!=null];
string subject = 'New Event Notification: ' + new_event.subject;
message.setSubject(subject);
string body = 'You have received a new event request for "' + new_event.subject + '". Please review your dashboard for further details.';
message.setPlainTextBody(body);
message.setTargetObjectId(c.Id);
message.setToAddresses(new String[] {c.Email});
Messaging.sendEmail(new Messaging.Email[] {message});
}

}