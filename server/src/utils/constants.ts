const DEFAULTS = {
  auth_needed_to_vote: false,
  // default to false opting social media account (also hidden in client-participation UI)
  //auth_needed_to_write: true,
  //auth_opt_allow_3rdparty: true,
  //auth_opt_fb: true,
  //auth_opt_tw: true,
  auth_needed_to_write: false,
  auth_opt_allow_3rdparty: false,
  auth_opt_fb: false,
  auth_opt_tw: false,  
};

export { DEFAULTS };

export default {
  DEFAULTS,
};
