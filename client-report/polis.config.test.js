// This file is deprecated since configuration unification update 17.2.2023
module.exports = {

  //SERVICE_URL: 'http://localhost:5000',
  //SERVICE_URL: 'https://preprod.pol.is',
  //SERVICE_URL: 'https://polis-test.digifinland.dev',
  SERVICE_URL: 'https://polis-test-gke.digifinland.dev',
  //SERVICE_URL: 'https://polis.local',

  UPLOADER: 'local', // alt: s3, scp

  // Uploader settings: local
  LOCAL_OUTPUT_PATH: './build',

  // Uploader settings: s3
  S3_BUCKET_PROD: 'pol.is',
  S3_BUCKET_PREPROD: 'preprod.pol.is',

  // Uploader settings: scp
  SCP_SUBDIR_PREPROD: 'preprod',
  SCP_SUBDIR_PROD: 'prod',
};
