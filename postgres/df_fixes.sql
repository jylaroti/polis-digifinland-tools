-- initial fix by DigiFinland:
-- ALTER TABLE "participants_extended" ADD "permanent_cookie" VARCHAR(256) NULL;
-- ALTER TABLE "participants_extended" ADD "origin" VARCHAR(256) NULL;

-- official fix from CompDem
ALTER TABLE participants_extended
ADD COLUMN permanent_cookie VARCHAR(32),
ADD COLUMN origin VARCHAR(9999);

-- set default as 0. disable email notifications on client-participation when it is not set by the admin. client-admin customization: configuration hidden for this value.
ALTER TABLE "conversations"
	ALTER COLUMN "subscribe_type" SET DEFAULT '0';

-- add following, if needed. current fix implented by commenting out code block that inserts ip-data when x-forwarded-for attribute is set in request.
-- ALTER TABLE "participants_extended" ADD "encrypted_ip_address" VARCHAR(256) NULL;
-- ALTER TABLE "participants_extended" ADD "encrypted_x_forwarded_for" VARCHAR(256) NULL;