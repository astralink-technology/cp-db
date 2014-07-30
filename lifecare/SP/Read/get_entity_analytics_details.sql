-- Drop function
DO $$
DECLARE fname text;
BEGIN
FOR fname IN SELECT oid::regprocedure FROM pg_catalog.pg_proc WHERE proname = 'get_entity_analytics_details' LOOP
  EXECUTE 'DROP FUNCTION ' || fname;
END loop;
RAISE INFO 'FUNCTION % DROPPED', fname;
END$$;
-- Start function
CREATE FUNCTION get_entity_analytics_details(
        pEntityId varchar(32)
        , pDeviceId varchar(32)
        , pAuthorizationLevels integer
        , pAuthenticationId varchar(32)
        , pPageSize integer
        , pSkipSize integer
    )
RETURNS TABLE(
	entity_id varchar(32)
	, first_name varchar(32) 
	, last_name varchar(32)
	, nick_name varchar(32)
	, name varchar(64)
	, status char(1)
	, location_name varchar(128)
	, approved boolean
	, type char(1)
	, create_date timestamp without time zone
	, last_update timestamp without time zone
	, authentication_id varchar(32)
	, primary_email_id varchar(32)
	, primary_phone_id varchar(32)
	, authorization_level int
	, last_login timestamp without time zone
	, last_logout timestamp without time zone
	, authentication_string varchar(64)
	, device_id varchar(32)
	, device_type char(1)
	, phone_id varchar(32)
	, digits varchar(32)
	, phone_digits varchar(32)
	, country_code varchar(4)
	, code varchar(8)
	, address_id varchar(32)
	, apartment varchar(64)
	, road_name text
	, road_name2 text
	, suite varchar(32)
	, zip varchar(16)
	, country varchar(128)
	, province varchar(128)
	, state varchar(128)
	, city varchar(128)
	, address_type char(1)
	, address_status char(1)
	, longitude decimal
	, latitude decimal
	, median_wakeup_time timestamp without time zone
	, median_sleeping_time timestamp without time zone
	, sleep_efficiency integer
	, sleep_efficiency_null_reason varchar(32)
	, away_probability integer
	, going_out_stats_cluster integer
	, going_out_stats_start integer
	, going_out_stats_end integer
	, return_home_stats_cluster integer
	, return_home_stats_start integer
	, return_home_stats_end integer
	, day_bathroom_usage_freq integer
	, night_bathroom_usage_freq integer
	, max_day_bathroom_usage_dur integer
	, median_day_bathroom_usage_dur integer
	, min_day_bathroom_usage_dur integer
	, max_night_bathroom_usage_dur integer
	, median_night_bathroom_usage_dur integer
	, min_night_bathroom_usage_dur integer
  , day_active_wellness integer
  , day_max_inactivity integer
  , night_active_wellness integer
  , night_max_inactivity integer
  , nights_away integer
	, total_rows integer
) AS
$BODY$
DECLARE
    totalRows integer;
BEGIN
    -- count the total rows
    SELECT
      COUNT(*)
    INTO STRICT
      totalRows
    FROM entity e INNER JOIN
    authentication a ON a.authentication_id = e.authentication_id  LEFT JOIN
    device_relationship dr ON dr.owner_id = e.entity_id LEFT JOIN
    device d ON d.device_id = dr.device_id;

    -- create a temp table to get the data
    CREATE TEMP TABLE admin_entity_device_relationship_init AS
      SELECT
        e.entity_id
        , e.first_name
        , e.last_name
        , e.nick_name
        , e.name
        , e.status
        , e.location_name
        , e.approved
        , e.type
        , a.create_date -- user create date
        , e.last_update
        , e.authentication_id
        , e.primary_email_id
        , e.primary_phone_id
        , a.authorization_level
        , a.last_login
        , a.last_logout
        , a.authentication_string
        , dr.device_id
        , d.type as device_type
        , p.phone_id
        , p.digits
        , p.phone_digits
        , p.country_code
        , p.code
        , ad.address_id
        , ad.apartment
        , ad.road_name
        , ad.road_name2
        , ad.suite
        , ad.zip
        , ad.country
        , ad.province
        , ad.state
        , ad.city
        , ad.type as address_type
        , ad.status as address_status
        , ad.longitude
        , ad.latitude
        , (SELECT ia.date_value2 FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'MW' ORDER BY ia.date_value DESC LIMIT 1) as median_wakeup_time
        , (SELECT ia.date_value2 FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'MS' ORDER BY ia.date_value DESC LIMIT 1) as median_sleeping_time
        , (SELECT ia.int_value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'SE' ORDER BY ia.date_value DESC LIMIT 1) as sleep_efficiency
        , (SELECT ia.value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'SE' ORDER By ia.date_value DESC LIMIT 1) as sleep_efficiency_null_reason
        , (SELECT ia.int_value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'AP' ORDER BY ia.date_value DESC LIMIT 1) as away_probability
        , (SELECT ia.int_value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'GO' ORDER BY ia.date_value DESC LIMIT 1) as going_out_stats_cluster
        , (SELECT ia.int_value2 FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'GO' ORDER BY ia.date_value DESC LIMIT 1) as going_out_stats_start
        , (SELECT ia.int_value3 FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'GO' ORDER BY ia.date_value DESC LIMIT 1) as going_out_stats_end
        , (SELECT ia.int_value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'RH' ORDER BY ia.date_value DESC LIMIT 1) as return_home_stats_cluster
        , (SELECT ia.int_value2 FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'RH' ORDER BY ia.date_value DESC LIMIT 1) as return_home_stats_start
        , (SELECT ia.int_value3 FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'RH' ORDER BY ia.date_value DESC LIMIT 1) as return_home_stats_end
        , (SELECT ia.int_value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'DBF' ORDER BY ia.date_value DESC LIMIT 1) as day_bathroom_usage_freq
        , (SELECT ia.int_value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'NBF' ORDER BY ia.date_value DESC LIMIT 1) as night_bathroom_usage_freq
        , (SELECT ia.int_value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'DBD' ORDER BY ia.date_value DESC LIMIT 1) as max_day_bathroom_usage_dur
        , (SELECT ia.int_value2 FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'DBD' ORDER BY ia.date_value DESC LIMIT 1) as median_day_bathroom_usage_dur
        , (SELECT ia.int_value3 FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'DBD' ORDER BY ia.date_value DESC LIMIT 1) as min_day_bathroom_usage_dur
        , (SELECT ia.int_value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'NBD' ORDER BY ia.date_value DESC LIMIT 1) as max_night_bathroom_usage_dur
        , (SELECT ia.int_value2 FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'NBD' ORDER BY ia.date_value DESC LIMIT 1) as median_night_bathroom_usage_dur
        , (SELECT ia.int_value3 FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'NBD' ORDER BY ia.date_value DESC LIMIT 1) as min_night_bathroom_usage_dur
        , (SELECT ia.int_value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'AVGACT' ORDER BY ia.date_value DESC LIMIT 1) as day_active_wellness
        , (SELECT ia.int_value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'DI' ORDER BY ia.date_value DESC LIMIT 1) as day_max_inactivity
        , (SELECT ia.int_value2 FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'AVGACT' ORDER BY ia.date_value DESC LIMIT 1) as night_active_wellness
        , (SELECT ia.int_value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'NI' ORDER BY ia.date_value DESC LIMIT 1) as night_max_inactivity
        , (SELECT ia.int_value FROM informative_analytics ia WHERE ia.owner_id = dr.device_id AND ia.type = 'NGA' ORDER BY ia.date_value DESC LIMIT 1) as nights_away
      FROM entity e INNER JOIN
      authentication a ON a.authentication_id = e.authentication_id LEFT JOIN
      device_relationship dr ON dr.owner_id = e.entity_id LEFT JOIN
      device d ON d.device_id = dr.device_id LEFT JOIN
      phone p ON p.owner_id = e.entity_id LEFT JOIN
      address ad ON ad.owner_id = e.entity_id   WHERE (
        ((pDeviceId IS NULL) OR (dr.device_id = pDeviceId)) AND
        ((pEntityId IS NULL) OR (e.entity_id = pEntityId)) AND
        ((pAuthorizationLevels IS NULL) OR (a.authorization_level = pAuthorizationLevels)) AND
        ((pAuthenticationId IS NULL) OR (e.authentication_id = pAuthenticationId))
      )
      LIMIT pPageSize OFFSET pSkipSize;

    RETURN QUERY

    SELECT
      *
      , totalRows
    FROM admin_entity_device_relationship_init;

END;
$BODY$
LANGUAGE plpgsql;