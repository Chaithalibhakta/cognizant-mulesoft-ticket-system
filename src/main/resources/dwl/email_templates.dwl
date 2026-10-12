%dw 2.0
output application/java

/*
  Email Templates Generator
  Customer acknowledgement and team notification emails according to specification.
*/

fun buildCustomerAckSubject(ticketId: String, priority: String) =
    "[" ++ ticketId ++ "] " ++ priority ++ " – we have your request"

fun buildCustomerAckBody(ticket: Object) =
    "Dear " ++ (ticket.customerName default "Valued Customer") ++ ",\n\n" ++
    "We have logged your support request and assigned it to our " ++ (ticket.teamDisplayName default ticket.team) ++ " team.\n\n" ++
    " Ticket Reference : " ++ ticket.ticketId ++ "\n" ++
    " Logged At        : " ++ (ticket.createdAt as String) ++ "\n" ++
    " Priority         : " ++ ticket.priority ++ "\n" ++
    " Product          : " ++ (ticket.productName default ticket.productCode) ++ "\n" ++
    " Category         : " ++ (ticket.categoryDisplayName default ticket.categoryCode) ++ "\n\n" ++
    "What you told us\n " ++ ticket.subject ++ "\n\n" ++
    "We will respond by " ++ (ticket.ackDueAt as String) ++ ". Our current target for a resolution is " ++ (ticket.resolutionDueAt as String) ++ ".\n\n" ++
    "To add information, reply to this email leaving the subject line unchanged so that it reaches the same ticket. You can also check progress at " ++ (ticket.statusUrl default ("/api/v1/tickets/" ++ ticket.ticketId)) ++ ".\n\n" ++
    (if (ticket.priority == "P1") "This request is being handled as a priority one incident. Our on-call engineer has been paged.\n\n" else "") ++
    "Regards,\n" ++
    "NPN Customer Support\n"

fun buildTeamNoticeSubject(priority: String, ticketId: String, categoryCode: String) =
    priority ++ " " ++ ticketId ++ " – " ++ categoryCode

fun buildTeamNoticeBody(ticket: Object) =
    "Ticket   : " ++ ticket.ticketId ++ "\n" ++
    "Priority : " ++ ticket.priority ++ " (rule " ++ (ticket.matchedRuleId default "DEFAULT") ++ ")\n" ++
    "Customer : " ++ (ticket.customerName default "Customer") ++ " (" ++ ticket.customerId ++ ") – " ++ (ticket.customerTier default "STANDARD") ++ "\n" ++
    "Product  : " ++ ticket.productCode ++ "\n" ++
    "Category : " ++ ticket.categoryCode ++ "\n" ++
    "Impact   : " ++ (ticket.affectedUserCount default 0 as String) ++ " users reported affected\n\n" ++
    "Subject\n " ++ ticket.subject ++ "\n\n" ++
    "Acknowledge by : " ++ (ticket.ackDueAt as String) ++ "\n" ++
    "Resolve by     : " ++ (ticket.resolutionDueAt as String) ++ "\n" ++
    "Assigned to    : " ++ (ticket.assignedTo default "UNASSIGNED") ++ "\n\n" ++
    "Open in console : " ++ (ticket.agentConsoleUrl default ("/console/tickets/" ++ ticket.ticketId)) ++ "\n\n" ++
    (if (ticket.isDefaultRoute == "Y") 
        "NOTE: no routing rule matched this ticket. It has been sent to the triage queue and the rule set needs review.\n" ++
        " category " ++ ticket.categoryCode ++ " / product " ++ ticket.productCode ++ "\n" ++
        " tier " ++ (ticket.customerTier default "UNKNOWN") ++ " / severity " ++ (ticket.statedSeverity default "UNKNOWN") ++ "\n\n"
     else "") ++
    (if (ticket.isUnassigned == true or ticket.status == "UNASSIGNED")
        "NOTE: no agent in " ++ ticket.team ++ " was available. This ticket is UNASSIGNED and needs a manual pick-up.\n\n"
     else "")
