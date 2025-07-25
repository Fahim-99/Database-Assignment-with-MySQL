-- 1. Find students with blood groups O+ and A-
SELECT firstname, lastname, fulladdress 
FROM studentpersonal 
WHERE bloodgroup IN ('O+', 'A-');

-- 2. Get department and subject info for subject code 'EE201'
SELECT d.departmentName, d.departmentCode, s.subjectTitle 
FROM subjects s 
JOIN departments d ON d.departmentCode = s.departmentCode 
WHERE s.subjectCode = 'EE201';

-- 3. Count of students per blood group with at least 2 students
SELECT s.bloodgroup, COUNT(*)  
FROM studentpersonal s 
GROUP BY s.bloodgroup 
HAVING COUNT(*) >= 2;

-- 4. Students enrolled in department CS101 with subject titles
SELECT sp.firstname, sp.lastname, sub.subjectTitle 
FROM studentpersonal sp 
JOIN courses c ON sp.studentId = c.studentId 
JOIN subjects sub ON c.subjectCode = sub.subjectCode 
WHERE sub.departmentCode = 'CS101';

-- 5. Total semester fee collected for Computer Science department
SELECT SUM(totalSemesterFees), COUNT(*) 
FROM studentacademic sa 
JOIN departments d ON sa.departmentCode = d.departmentCode 
WHERE d.departmentName = 'Computer Science';

-- 6. Update semester fee by 10% for students in CS101 department
SELECT studentId, totalSemesterFees,  
       totalSemesterFees * 1.10 AS updated_fee 
FROM studentacademic 
WHERE departmentCode = 'CS101';

-- 7. Students and their teachers enrolled in CS101
SELECT 
 sp.firstname AS student_firstname, 
 sp.lastname AS student_lastname, 
 tp.firstname AS teacher_firstname, 
 ta.designation AS teacher_designation 
FROM studentacademic sa 
JOIN studentpersonal sp ON sa.studentId = sp.studentId 
JOIN teacheracademic ta ON sa.departmentCode = ta.departmentCode 
JOIN teacherpersonal tp ON ta.teacherId = tp.teacherId 
WHERE sa.departmentCode = 'CS101';

-- 8. Student and teacher from the same city
SELECT 
 sp.firstname AS student_firstname, 
 tp.lastname AS teacher_lastname,  
 sp.city 
FROM studentpersonal sp 
JOIN teacherpersonal tp ON sp.city = tp.city;

-- 9. Students enrolled in 'Algorithms' subject
SELECT sp.firstname, sp.lastname, c.subjectCode, s.subjectTitle 
FROM courses c 
JOIN studentpersonal sp ON c.studentId = sp.studentId 
JOIN subjects s ON c.subjectCode = s.subjectCode 
WHERE s.subjectTitle = 'Algorithms';

-- 10. Promote teachers based on designation
SELECT ta.teacherId, tp.firstname, ta.Designation, 
 CASE 
   WHEN Designation = 'Lecturer' THEN 'Sr. Lecturer' 
   WHEN Designation = 'Sr. Lecturer' THEN 'Associate Professor' 
   ELSE Designation 
 END AS promoted_to 
FROM teacheracademic ta 
JOIN teacherpersonal tp ON ta.teacherId = tp.teacherId;

-- 11. Teacher with the second highest salary
SELECT tp.firstname, tp.lastname 
FROM teacherpersonal tp 
JOIN teacheracademic ta ON tp.teacherId = ta.teacherId 
WHERE ta.salary = ( 
 SELECT MAX(salary) 
 FROM teacheracademic  
 WHERE salary < ( 
   SELECT MAX(salary) 
   FROM teacheracademic 
 ) 
);

-- 12. Students under the teacher with the second highest salary
SELECT 
 tp.firstname AS teacher_firstname, tp.lastname AS teacher_lastname, 
 sp.firstname AS student_firstname, sp.lastname AS student_lastname, 
 sp.city, sa.departmentCode 
FROM teacheracademic ta 
JOIN teacherpersonal tp ON ta.teacherId = tp.teacherId 
JOIN studentacademic sa ON ta.departmentCode = sa.departmentCode 
JOIN studentpersonal sp ON sa.studentId = sp.studentId 
WHERE ta.salary = ( 
 SELECT MAX(salary) 
 FROM teacheracademic 
 WHERE salary < ( 
   SELECT MAX(salary) 
   FROM teacheracademic 
 ) 
);