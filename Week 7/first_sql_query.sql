USE operating_system;

-- John has a old CPU lying around, and he wants to build a computer with it. His CPU only has two cores, but is capable of a speed of 1.6 GHZ
-- and an architecture of x86. John wants to know what operating system he can run before he buys the computer parts. List a set of operating
-- list the compatible Operating systems sorted by price 

SELECT os.os_name, os.cost, mc.num_cores AS "CPU Cores", mc.speed AS "CPU Speed", a.architecture_type
FROM operating_system os 
	JOIN required_specs rs ON os.required_specs_id = rs.required_specs_id
    JOIN min_cpu mc ON rs.min_cpu_id = mc.min_cpu_id
    JOIN architecture a ON mc.architecture_id = a.architecture_id
WHERE mc.num_cores <= 2 AND CAST(mc.speed AS SIGNED) <= 1.6 AND a.architecture_type LIKE "x86"
ORDER BY os.cost;