-- Always copy the function name and the parameters below to this section before changing the stored procedure
DROP FUNCTION IF EXISTS create_eye_orcas_account_types();
-- Start function
CREATE FUNCTION create_eye_orcas_account_types()
RETURNS BOOL AS
$BODY$
BEGIN
      /* Delete products and re-instate every execution */
      DELETE FROM product_value where
      product_id IN
      (
        SELECT product_id from product
        where code IN
        (
          'EYEORCAS-STARTER'
        )
      );
      DELETE FROM product where
      code IN
      (
          'EYEORCAS-STARTER'
      );

      INSERT INTO product(
          product_id
          , name
          , description
          , status
          , type
          , code
          , create_date
          , last_update
      ) VALUES(
          'NW41GL7D-2ZQLOTQB-1INKCWE0'
          , 'Alpha Starter'
          , 'Alpha starter account.'
          , 'V'
          , 'A'
          , 'EYEORCAS-STARTER'
          , null
          , null
      );
      /* disk space */
      INSERT INTO product_value(
        product_value_id
        , product_value_name
        , value
        , value2
        , value3
        , value_unit
        , status
        , type
        , create_date
        , last_update
        , product_id
      ) VALUES(
          '7X48UGQR-G4J4AOGU-1IY4XH1H'
        , 'Storage'
        , 500
        , null
        , null
        , 'GB'
        , 'V'
        , 'S'
        , null
        , null
        , 'NW41GL7D-2ZQLOTQB-1INKCWE0'
      );

      /* Push Notifications */
      INSERT INTO product_value(
        product_value_id
        , product_value_name
        , value
        , value2
        , value3
        , value_unit
        , status
        , type
        , create_date
        , last_update
        , product_id
      ) VALUES(
          'AC669JLF-1T0CD61M-P1QGTEQL'
        , 'Push Notification'
        , 5000
        , null
        , null
        , null
        , 'V'
        , 'P'
        , null
        , null
        , 'NW41GL7D-2ZQLOTQB-1INKCWE0'
      );

      /* SMSes */
      INSERT INTO product_value(
        product_value_id
        , product_value_name
        , value
        , value2
        , value3
        , value_unit
        , status
        , type
        , create_date
        , last_update
        , product_id
      ) VALUES(
          'IOIOS1R6-DAWZR48J-4SMU00EE'
        , 'SMS'
        , 5000
        , null
        , null
        , null
        , 'V'
        , 'M'
        , null
        , null
        , 'NW41GL7D-2ZQLOTQB-1INKCWE0'
      );

      RETURN TRUE;
END;
$BODY$
LANGUAGE plpgsql;