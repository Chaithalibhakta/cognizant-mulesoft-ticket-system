%dw 2.0
var toSf = {
  NEW: "New", UNASSIGNED: "Unassigned", ASSIGNED: "Assigned",
  IN_PROGRESS: "In Progress", PENDING_CUSTOMER: "Pending Customer",
  RESOLVED: "Resolved", CLOSED: "Closed", CANCELLED: "Cancelled"
}
fun toSalesforce(s) = toSf[s] default s
fun fromSalesforce(s) =
  (toSf pluck ((v, k) -> { sf: v, mule: k as String }) filter ($.sf == s))[0].mule default s