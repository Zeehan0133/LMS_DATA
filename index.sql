-- create index ...
 create index my_count_index ON `cpulogdata2019-11-17-new`(`Cpu Count`);
 select `Cpu Count` from `cpulogdata2019-11-17-new`
  where `Cpu Count`=4;

-- show index...
show index from `cpulogdata2019-11-17-new`;

-- drop index..
  alter table `cpulogdata2019-11-17-new`  drop index my_count_index  ;


-- create index in cpulog data table
create index tech_index on  `cpulogdata2019-11-17-new` (technology(276));
select technology from `cpulogdata2019-11-17-new` where technology ='java';
