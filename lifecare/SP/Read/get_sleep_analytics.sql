--wake up algorithm
select create_date from eyecare where create_date between '2014-05-05T05:00' AND '2014-05-05T23:00:00'
and event_type_id NOT IN ('20010', '20004') and
-- device_id = 'z0a783989897' --tee
-- device_id = 'z0a78300b00b' --goh
-- device_id = 'z0a783118008' --suraya
order by create_date asc limit 1

--sleeping algorithm
select create_date from eyecare where create_date between '2014-05-05T23:00' AND '2014-05-05T5:00:00'
create

order by create_date asc limit 1

select e.*
from (select e.*,
             lag(create_date) over (order by create_date asc) as prev_create_date
      from eyecare e
     ) e
where prev_create_date < create_date - 2 * interval '1 hour'
and e.device_id = 'z0a783989897' --tee
and create_date between '2014-05-04T23:00' AND '2014-05-05T5:00:00';

select e.*
from (select e.*,
             lag(create_date) over (order by create_date) as prev_create_date,
             lead(create_date) over (order by create_date) as next_create_date
      from eyecare e
     ) e
where prev_create_date < create_date - 2 * interval '1 hour' or
      next_create_date > create_date + 2 * interval '1 hour'
and e.device_id = 'z0a783989897' --tee
and e.create_date between '2014-05-04T23:00' AND '2014-05-05T5:00:00'
order by create_date;


select e.name, dr.device_id from entity e inner join device_relationship dr on dr.owner_id = e.entity_id