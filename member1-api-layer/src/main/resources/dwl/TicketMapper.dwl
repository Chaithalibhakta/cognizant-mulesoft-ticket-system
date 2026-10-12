%dw 2.0
import fromSalesforce from dwl::StatusMap
fun toContract(t) = {
  sfId: t.Id,
  ticketId: t.Name,
  requestId: t.Request_ID__c,
  status: fromSalesforce(t.Ticket_Status__c default "New"),
  priority: t.Priority__c,
  team: t.Assigned_Team__c,
  ackDueAt: t.Acknowledgement_Due_At__c as String,
  resolutionDueAt: t.Resolution_Due_At__c as String,
  createdAt: t.CreatedDate as String
}