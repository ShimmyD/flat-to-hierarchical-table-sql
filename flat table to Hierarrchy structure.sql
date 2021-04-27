 -- use recursive CTE to query hierarchical employee data to create a hierarchical level column
with org_chart (
  TableID,Dept, Branch, Employee_id, Employee_name,Employee_position, Supervisor_name, Supervisor_id,Hrstatus, lvl,Update_date
) as (
	  select TABLEID,Dept, Branch, EmployeeID, Firstname+' '+Lastname, Position,Supervisor,SupervisorEmployeeID,  1 as lvl
	  from   PSEMPLOYEE
	  union  all
	  select e.TABLEID,e.Dept, e.Branch, EmployeeID, Firstname+' '+Lastname, Position,Supervisor,SupervisorEmployeeID, oc.lvl + 1
	  from  PSEMPLOYEE e
	  join    org_chart oc
	  on     e.SupervisorEmployeeID = oc.Employee_id
)  
------use level column to link parent and children and create parentID column
 ,hierarchy_parent_child as (
    select
      TableID, Dept, Branch,Employee_id, Employee_name, Employee_position,Supervisor_name, Supervisor_id,Hrstatus, lvl, p.ParentId
    from org_chart as c
           CROSS APPLY (SELECT Max(Employee_id) as ParentId
                          FROM org_chart
                         WHERE lvl = c.lvl - 1
                           AND Employee_id =  Substring(c.Supervisor_id, Patindex('%[^0 ]%',c.Supervisor_id+ ' '), Len(c.Supervisor_id))
                       ) p  
    )

---use join to turn a flat employee table to a hierarchical employee table

-- create top three hierarchical levels Director, GS and superivosr. Top level is always director, but the hierarchyy can go down many different levels in different section.
-- To ensure we capture all levels we extend hierarchical level to 9th level
SELECT
	Director.Employee_id lvl_01_Employee_id, Director.Employee_name Director,
	GS.Employee_id lvl_02_Employee_id, GS.Employee_name GS,
	Supervisor.Employee_id lvl_03_Empolyee_id, Supervisor.Employee_name Supervisor,
	case 
		when  lev04.Employee_name is  null  
		then  Supervisor.Employee_name 
		else
		lev04.Employee_name
		end  as Employee_name,
	case 
		when  lev04.Employee_name is  null  
		then cast (Substring(Supervisor.Employee_id, Patindex('%[^0 ]%',Supervisor.Employee_id+ ' '), Len(Supervisor.Employee_id) ) as int) 
		else
		cast (Substring(lev04.Employee_id, Patindex('%[^0 ]%',lev04.Employee_id+ ' '), Len(lev04.Employee_id) ) as int) 
		end  as Employee_id
	
FROM 
	hierarchy_parent_child Director
	LEFT OUTER JOIN hierarchy_parent_child GS ON Director.Employee_id = GS.ParentID
	LEFT OUTER JOIN hierarchy_parent_child Supervisor ON GS.Employee_id = Supervisor.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev04 ON Supervisor.Employee_id = lev04.ParentID
WHERE 
	Director.ParentID IS NULL --and lev04.Employee_name is not null

union

--add fourth level after superviosr by union
SELECT
	Director.Employee_id lvl_01_Employee_id, Director.Employee_name Director,
	GS.Employee_id lvl_02_Employee_id, GS.Employee_name GS,
	Supervisor.Employee_id lvl_03_Empolyee_id, Supervisor.Employee_name Supervisor,
	case 
		when  lev05.Employee_name is  null  
		then  Supervisor.Employee_name 
		else
		lev05.Employee_name
		end  as Employee_name,
	case 
		when  lev05.Employee_name is  null  
		then cast (Substring(Supervisor.Employee_id, Patindex('%[^0 ]%',Supervisor.Employee_id+ ' '), Len(Supervisor.Employee_id) ) as int) 
		else
		cast (Substring(lev05.Employee_id, Patindex('%[^0 ]%',lev05.Employee_id+ ' '), Len(lev05.Employee_id) ) as int) 
		end  as Employee_id
FROM 
	hierarchy_parent_child Director
	LEFT OUTER JOIN hierarchy_parent_child GS ON Director.Employee_id = GS.ParentID
	LEFT OUTER JOIN hierarchy_parent_child Supervisor ON GS.Employee_id = Supervisor.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev04 ON Supervisor.Employee_id = lev04.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev05 ON lev04.Employee_id = lev05.ParentID
WHERE 
	Director.ParentID IS NULL-- and lev05.Employee_name is not null

union 
--add fifth level 
SELECT
	Director.Employee_id lvl_01_Employee_id, Director.Employee_name Director,
	GS.Employee_id lvl_02_Employee_id, GS.Employee_name GS,
	Supervisor.Employee_id lvl_03_Empolyee_id, Supervisor.Employee_name Supervisor,
	case 
		when  lev06.Employee_name is  null  
		then  Supervisor.Employee_name 
		else
		lev06.Employee_name
		end  as Employee_name,
	case 
		when  lev06.Employee_name is  null  
		then cast (Substring(Supervisor.Employee_id, Patindex('%[^0 ]%',Supervisor.Employee_id+ ' '), Len(Supervisor.Employee_id) ) as int) 
		else
		cast (Substring(lev06.Employee_id, Patindex('%[^0 ]%',lev06.Employee_id+ ' '), Len(lev06.Employee_id) ) as int) 
		end  as Employee_id
FROM 
	hierarchy_parent_child Director
	LEFT OUTER JOIN hierarchy_parent_child GS ON Director.Employee_id = GS.ParentID
	LEFT OUTER JOIN hierarchy_parent_child Supervisor ON GS.Employee_id = Supervisor.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev04 ON Supervisor.Employee_id = lev04.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev05 ON lev04.Employee_id = lev05.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev06 ON lev05.Employee_id = lev06.ParentID
WHERE 
	Director.ParentID IS NULL ---and lev06.Employee_name is not null

union 

-- add sixth level
SELECT
	Director.Employee_id lvl_01_Employee_id, Director.Employee_name Director,
	GS.Employee_id lvl_02_Employee_id, GS.Employee_name GS,
	Supervisor.Employee_id lvl_03_Empolyee_id, Supervisor.Employee_name Supervisor,
	case 
		when  lev07.Employee_name is  null  
		then  Supervisor.Employee_name 
		else
		lev07.Employee_name
		end  as Employee_name,
	case 
		when  lev07.Employee_name is  null  
		then cast (Substring(Supervisor.Employee_id, Patindex('%[^0 ]%',Supervisor.Employee_id+ ' '), Len(Supervisor.Employee_id) ) as int) 
		else
		cast (Substring(lev07.Employee_id, Patindex('%[^0 ]%',lev07.Employee_id+ ' '), Len(lev07.Employee_id) ) as int) 
		end  as Employee_id

FROM 
	hierarchy_parent_child Director
	LEFT OUTER JOIN hierarchy_parent_child GS ON Director.Employee_id = GS.ParentID
	LEFT OUTER JOIN hierarchy_parent_child Supervisor ON GS.Employee_id = Supervisor.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev04 ON Supervisor.Employee_id = lev04.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev05 ON lev04.Employee_id = lev05.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev06 ON lev05.Employee_id = lev06.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev07 ON lev06.Employee_id = lev07.ParentID
WHERE
	 Director.ParentID IS NULL --and lev07.Employee_name is not null

union

--add seventh level
SELECT
	Director.Employee_id lvl_01_Employee_id, Director.Employee_name Director,
	GS.Employee_id lvl_02_Employee_id, GS.Employee_name GS,
	Supervisor.Employee_id lvl_03_Empolyee_id, Supervisor.Employee_name Supervisor,
	case 
		when  lev08.Employee_name is  null  
		then  Supervisor.Employee_name 
		else
		lev08.Employee_name
		end  as Employee_name,
	case 
		when  lev08.Employee_name is  null  
		then cast (Substring(Supervisor.Employee_id, Patindex('%[^0 ]%',Supervisor.Employee_id+ ' '), Len(Supervisor.Employee_id) ) as int) 
		else
		cast (Substring(lev08.Employee_id, Patindex('%[^0 ]%',lev08.Employee_id+ ' '), Len(lev08.Employee_id) ) as int) 
		end  as Employee_id

FROM 
	hierarchy_parent_child Director
	LEFT OUTER JOIN hierarchy_parent_child GS ON Director.Employee_id = GS.ParentID
	LEFT OUTER JOIN hierarchy_parent_child Supervisor ON GS.Employee_id = Supervisor.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev04 ON Supervisor.Employee_id = lev04.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev05 ON lev04.Employee_id = lev05.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev06 ON lev05.Employee_id = lev06.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev07 ON lev06.Employee_id = lev07.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev08 ON lev07.Employee_id = lev08.ParentID
WHERE
	 Director.ParentID IS NULL --and lev08.Employee_name is not null

union


--add eighth level
SELECT
	Director.Employee_id lvl_01_Employee_id, Director.Employee_name Director,
	GS.Employee_id lvl_02_Employee_id, GS.Employee_name GS,
	Supervisor.Employee_id lvl_03_Empolyee_id, Supervisor.Employee_name Supervisor,
	case 
		when  lev09.Employee_name is  null  
		then  Supervisor.Employee_name 
		else
		lev09.Employee_name
		end  as Employee_name,
	case 
		when  lev09.Employee_name is  null  
		then cast (Substring(Supervisor.Employee_id, Patindex('%[^0 ]%',Supervisor.Employee_id+ ' '), Len(Supervisor.Employee_id) ) as int) 
		else
		cast (Substring(lev09.Employee_id, Patindex('%[^0 ]%',lev09.Employee_id+ ' '), Len(lev09.Employee_id) ) as int) 
		end  as Employee_id

FROM 
	hierarchy_parent_child Director
	LEFT OUTER JOIN hierarchy_parent_child GS ON Director.Employee_id = GS.ParentID
	LEFT OUTER JOIN hierarchy_parent_child Supervisor ON GS.Employee_id = Supervisor.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev04 ON Supervisor.Employee_id = lev04.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev05 ON lev04.Employee_id = lev05.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev06 ON lev05.Employee_id = lev06.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev07 ON lev06.Employee_id = lev07.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev08 ON lev07.Employee_id = lev08.ParentID
	LEFT OUTER JOIN hierarchy_parent_child lev09 ON lev08.Employee_id = lev09.ParentID
WHERE
	 Director.ParentID IS NULL 

