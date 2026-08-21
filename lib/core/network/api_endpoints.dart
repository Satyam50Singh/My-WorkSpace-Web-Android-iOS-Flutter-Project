class ApiEndpoints {
  ApiEndpoints._();

  static const baseUrl = "https://apiuat.fsuite.tech/api";

  static const validateCompanyCode = "/Master/Validate_Company_Code";
  static const employeeLogin = "/Master/Validate_Login_V6_Web";

  // -- Ticketing Module APIs -- //
  static const fetchTicketMyRequestDetails = "/Ticketing/Fetch_Ticket_MyRequest_Web_API";

  static const fetchViewTicketDetailsV6  = "/Ticketing/View_Ticket_Details_V6";
  static const fetchViewTicketWorkflowDetails = "/Ticketing/View_Ticket_Workflow_Details_Web_API";
  static const fetchViewTicketActionHistory = "/Ticketing/View_Ticket_Action_History";

}
