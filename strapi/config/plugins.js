module.exports = ({ env }) => ({
    upload: {
      config: {
        provider: '@strapi-community/strapi-provider-upload-google-cloud-storage',
        providerOptions: {
            bucketName: env('GCS_BUCKET_NAME'),
            serviceAccount: env.json('GCS_SERVICE_ACCOUNT'),
            publicFiles: true,
            uniform: false,
        },
      },
    },
});