class ApiEndpoints {
  ApiEndpoints._();

  static const baseUatUrl = "https://apiuat.fsuite.tech/api";
  static const baseProdUrl = "https://apinew.fsuite.tech/api";

  static String baseUrl = baseUatUrl;

  static const validateCompanyCode = "/Master/Validate_Company_Code";
  static const employeeLogin = "/Master/Validate_Login_V6_Web";

  // -- Ticketing Module APIs -- //
  static const fetchTicketMyRequestDetails = "/Ticketing/Fetch_Ticket_MyRequest_Web_API";

  static const fetchViewTicketDetailsV6  = "/Ticketing/View_Ticket_Details_V6";
  static const fetchViewTicketWorkflowDetails = "/Ticketing/View_Ticket_Workflow_Details_Web_API";
  static const fetchViewTicketActionHistory = "/Ticketing/View_Ticket_Action_History";

  static const submitReOpenReviewTicket = "/Ticketing/Submit_ReOpen_Review_Ticket_Web";

  static const fetchTicketLocationCategoryV2 = "/Ticketing/Fetch_Ticket_Location_Category_V2";
  static const fetchTicketSubCategory = "/Ticketing/Fetch_Ticket_Sub_Category";
  static const fetchTicketWorkflowDetailsV2  = "/Ticketing/View_Ticket_Workflow_Details_V2";
  static const fetchTicketRequestDetailsV4 = "/Ticketing/Ticket_Request_Details_V4";

  static const fetchTicketMyActionableDetails = "/Ticketing/Fetch_Ticket_MyActionable_Web_API";
  static const acceptWebTicket = "/Ticketing/Accept_Ticket_Web";
  static const updateTicketActionV4 = "/Ticketing/Update_Ticket_Action_V4";
  static const fetchTicketTransferUserList = "/Ticketing/Fetch_Ticket_TransferUser_List";
  static const transferTicketWeb = "/Ticketing/Transfer_Ticket_Web";
  static const transferToOtherWorkflow = "/Ticketing/Ticket_Transfer_To_Other_Workflow_Web";

  static const fetchTicketCategoryList = "/Ticketing/Fetch_Ticket_Category_List";
  static const fetchMasterDepartmentList = "/Ticketing/Fetch_Master_Department_List";
  static const insertUpdateTicketCategory = "/Ticketing/Insert_Update_Ticket_Category";

}
