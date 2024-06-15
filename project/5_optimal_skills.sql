-- Запрос выдаст нам список 25 навыков, которые пользуются высоким спросом среди аналитиков данных

WITH skill_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND salary_year_avg is NOT NULL
        AND job_work_from_home = True
    GROUP BY 
        skills_dim.skill_id
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) as avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' 
        AND salary_year_avg is NOT NULL
        AND job_work_from_home = True
    GROUP BY 
        skills_job_dim.skill_id
)

SELECT
    skill_demand.skill_id,
    skill_demand.skills,
    demand_count,
    avg_salary
FROM
    skill_demand
INNER JOIN average_salary ON skill_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25;