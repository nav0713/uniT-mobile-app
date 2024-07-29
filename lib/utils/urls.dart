class Url {
  static final Url _instance = Url();

  static Url get instance => _instance;

  String host() {
    // return '192.168.80.15:3000';xp
    return 'agusandelnorte.gov.ph';
    // return "192.168.10.219:3000";
    // live local return "192.168.10.241";
    // return "192.168.10.221:3004";
    // return "playweb.agusandelnorte.gov.ph";
    // return 'devapi.agusandelnorte.gov.ph:3004';
    // return "192.168.10.218:8000";
    // return '10.0.2.2:3000';
    // return '10.10.10.100:3000';
  }

  String prefixHost() {
    return "https://";
    // return "http://";
  }

  String authentication() {
    return '/api/account/auth/login/';
  }

  String profileInformation() {
    return '/api/jobnet_app/profile/pds/';
  }

  String generateQRCode(){
    return "/api/profile_app/person_basicinfo/generate_uuid/";
  }

  String latestApk() {
    return "/api/system_app/apk_version/latest/";
  }

  ////SOS paths
  String sosRequest() {
    return "/api/sos_app/sos_request/";
  }

  //// DOCSMS paths
  String getDocument() {
    return "/api/web_app/public/document_viewer/";
  }

////ELIGIBILITIES PATHS
  String eligibilities() {
    return "/api/jobnet_app/eligibilities/";
  }

  String getEligibilities() {
    return "/api/jobnet_app/profile/pds/eligibility/";
  }

  String addEligibility() {
    return "/api/jobnet_app/profile/pds/eligibility/";
  }

  String deleteEligibility() {
    return "/api/jobnet_app/profile/pds/eligibility/";
  }

  String updateEligibility() {
    return "/api/jobnet_app/profile/pds/eligibility/";
  }

//// work history paths
  String workhistory() {
    return "/api/jobnet_app/profile/pds/work_experience/";
  }

  String deleteWorkHistory() {
    return "/api/jobnet_app/profile/pds/work/";
  }

  String getPositions() {
    return "/api/jobnet_app/positions/";
  }

  String getAgencies() {
    return "/api/jobnet_app/agencies/";
  }
  String getPaginatedAgency(){
    return "/api/jobnet_app/agencies/";
  }

  String getAgencyCategory() {
    return "/api/jobnet_app/agency_categories/";
  }

  String identifications() {
    return "/api/jobnet_app/profile/pds/basic/identification/";
  }

////educational background paths
  String educationalBackground() {
    return "/api/jobnet_app/profile/pds/education/";
  }

  String getSchools() {
    return "/api/jobnet_app/schools/";
  }

  String getPrograms() {
    return "/api/jobnet_app/education_programs/";
  }

  String getHonors() {
    return "/api/jobnet_app/honors";
  }

//// learning and development paths

  String learningAndDevelopments() {
    return "/api/jobnet_app/profile/pds/learning_development/";
  }

  String conductedTrainings() {
    return "/api/jobnet_app/conducted_trainings/";
  }

  String learningAndDevelopmentType() {
    return "/api/jobnet_app/learning_development/";
  }

  String learningAndDevelopmentTopics() {
    return "/api/jobnet_app/training_topics/";
  }

//// references paths
  String reference() {
    return "/api/jobnet_app/profile/pds/personal_reference/";
  }

////voluntary works
  String getVoluntaryWorks() {
    return "/api/jobnet_app/profile/pds/voluntary_work/";
  }

//// skills hobbies
  String skillsHobbies() {
    return "/api/jobnet_app/profile/pds/other/skill_hobby/";
  }

  String getAllSkillsHobbies() {
    return "/api/jobnet_app/skill_hobby/";
  }

//// orgmemberships
  String getOrgMemberShips() {
    return "/api/jobnet_app/profile/pds/other/org_membership/";
  }

////non academic recognition
  String getNonAcademicRecognition() {
    return "/api/jobnet_app/profile/pds/other/non_acad_recognition/";
  }

////citizenship
  String citizenship() {
    return "/api/jobnet_app/profile/pds/basic/citizenship/";
  }

////family paths
  String getFamilies() {
    return "/api/jobnet_app/profile/pds/family/";
  }

  String addEmergency() {
    return "/api/profile_app/person_emergency/";
  }

  String getRelationshipTypes() {
    return "/api/jobnet_app/relationship_types";
  }

  String updatePersonalInfor() {
    return "/api/jobnet_app/profile/pds/basic/personal/";
  }

//// contacts path
  String getServiceTypes() {
    return "/api/jobnet_app/comm_service_type/";
  }

  String attachments() {
    return "/api/jobnet_app/profile/attachment/";
  }

//// address path
  String addressPath() {
    return "/api/jobnet_app/profile/pds/basic/address/";
  }

  String contactPath() {
    return "/api/jobnet_app/profile/pds/basic/contact/";
  }

  String getCommunicationProvider() {
    return "/api/jobnet_app/comm_services/";
  }

  String deleteContact() {
    return "/api/jobnet_app/profile/pds/basic/contact/";
  }

////profile other info
  String getReligions() {
    return "/api/profile_app/religion/";
  }

  String getEthnicity() {
    return "/api/profile_app/ethnicity/";
  }

  String getDisability() {
    return "/api/profile_app/disability/";
  }

  String getIndigency() {
    return "/api/profile_app/indigenous/";
  }

  String getGenders() {
    return "/api/profile_app/gender/";
  }

/////ROLES
// pass check
  String getAssignAreas() {
    return "/api/account/auth/assigned_role_area/";
  }

  String getPasserInfo() {
    return "/api/profile_app/person_basicinfo/";
  }

  String postLogs() {
    return "/api/unit2_app/monitoring/pass_check/";
  }

  String passCheck() {
    return "/api/unit2_app/monitoring/pass_check";
  }

  String getLogs() {
    return "/api/unit2_app/monitoring/pass_check_logs";
  }
////rbac

  String getRbacRoles() {
    return "/api/account/auth/roles/";
  }

  String searchUsers() {
    return "/api/hrms_app/employee_details/";
  }

  String assignRbac() {
    return "/api/account/auth/rbac/";
  }

////rbac operations
  String getRbacOperations() {
    return "/api/account/auth/operations/";
  }

  String getPersmissions() {
    return "/api/account/auth/permissionrbac/";
  }

  String getRoles() {
    return "/api/account/auth/roles/";
  }

  String getOperations() {
    return "/api/account/auth/operations/";
  }

  String getModules() {
    return "/api/account/auth/modules/";
  }

  String getObject() {
    return "/api/account/auth/objects/";
  }

  String getModuleObjects() {
    return "/api/account/auth/moduleobject/";
  }

  String agencies() {
    return "/api/jobnet_app/agencies/";
  }

  String postAgencies() {
    return "/api/profile_app/agencies/";
  }

  String getRoleModules() {
    return "/api/account/auth/rolemodules/";
  }

  String getRolesUnder() {
    return "/api/account/auth/rolesunder/";
  }

  String getRoleExtend() {
    return "/api/account/auth/rolesextend/";
  }

  String getStation() {
    return "/api/hrms_app/station/";
  }

  String postStation() {
    return "/api/hrms_app/stations/";
  }

  String getRoleAssignment() {
    return "/api/account/auth/role_assignment/";
  }

  String getPermissionAssignment() {
    return "/api/account/auth/permission_assignment/";
  }

  String getStationType() {
    return "/api/hrms_app/station_type/";
  }

  String getPositionTitle() {
    return "/api/hrms_app/position_title/";
  }

  String getAssignedAreas() {
    return "/api/account/auth/assigned_role_area";
  }

  //// location utils path
  String getCounties() {
    return "/api/jobnet_app/countries/";
  }

  String getRegions() {
    return "/api/web_app/location/region/";
  }

  String getProvinces() {
    return "/api/web_app/location/province/";
  }

  String getCities() {
    return "/api/web_app/location/citymun/";
  }

  String getBarangays() {
    return "/api/web_app/location/barangay/";
  }

  String getPurok() {
    return "/api/web_app/location/purok/";
  }

  String getAddressCategory() {
    return "/api/jobnet_app/address_categories/";
  }

  ////passo path

  ////communication path
  String getMessages(){
    return "/api/commservice_app/recipient/";
  }

  String attachmentCategories() {
    return "/api/jobnet_app/attachment_categories/";
  }
}
