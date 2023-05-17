--형변환함수
--자동형변환
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = '30'; --자동형변환
SELECT SYSDATE-5, SYSDATE-'5' FROM EMPLOYEES; --자동형변환

--강제형변환
--TO_CHAR(날짜, 날짜포맷)
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM DUAL; --문자
SELECT TO_CHAR(SYSDATE,'YY/MM/DD HH24/MI/SS') FROM DUAL;--문자
SELECT TO_CHAR(SYSDATE, 'YYYY"년"MM"월"DD"일"') FROM DUAL; --포맷문자가 아닌경우 ""로 묶어줍니다
SELECT TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') FROM EMPLOYEES;

--TO_CHAR(숫자,숫자포맷)
SELECT TO_CHAR(200000,'$999,999,999') FROM DUAL;
SELECT TO_CHAR(200000,'999999.999') FROM DUAL; --소수점 자리 표현
SELECT TO_CHAR(SALARY * 1300,'L999,999,999') FROM EMPLOYEES;
SELECT FIRST_NAME, TO_CHAR(SALARY*1300,'L0999,999,999') FROM EMPLOYEES; --자리수를 0으로 채움

--TO_NUMBER(문자, 숫자포맷)
SELECT '3.14' + 2000 FROM DUAL; --자동형변환
SELECT TO_NUMBER('3.14') + 2000 FROM DUAL; --명시적형변환
SELECT TO_NUMBER('$3,300','$999,999') + 2000 FROM DUAL;

--TO_DATE(문자, 날짜포맷)
SELECT SYSDATE - '2023-05-16' FROM DUAL; --ERROR
SELECT SYSDATE - TO_DATE('2023-05-16','YYYY-MM-DD') FROM DUAL; 
SELECT SYSDATE - TO_DATE('2023/05/16 11:31:23','YYYY/MM/DD HH:MI:SS')FROM DUAL;

--아래값을 YYYY년MM월DD일 형태로 출력
SELECT TO_CHAR(TO_DATE('20050105' ,'YYYYMMDD'),'YYYY"년"MM"월"DD"일"') FROM DUAL;

--아래값과 현재날짜와 일수 차이를 구하세요
SELECT SYSDATE -TO_DATE('2005년01월05일','YYYY"년"MM"월"DD"일"') FROM DUAL;

--------------------------------------------------------
--NULL값에 대한 변환 
--NTL(컬럼, NULL일경우 처리)
SELECT NVL(NULL,0) FROM DUAL;
SELECT FIRST_NAME, COMMISSION_PCT*100 FROM EMPLOYEES; --NULL연산시 ->NULL
SELECT FIRST_NAME, NVL(COMMISSION_PCT,0) *100 FROM EMPLOYEES;

--NVL2(컬럼, NULL이 아닌경우처리, NULL인 경우처리)
SELECT NVL2(NULL,'널이아닙니다','널입니다') FROM DUAL;
SELECT SALARY,
       NVL2(COMMISSION_PCT, (SALARY*COMMISSION_PCT) , SALARY) AS 급여
FROM EMPLOYEES; -- 총 월급이 얼마인가 

--DECODE() - ELSE IF 문을 대체하는 함수
SELECT DECODE('D','A','A입니다',
                  'B','B입니다',
                  'C','C입니다',
                  'ABC가 아닙니다') FROM DUAL;

SELECT JOB_ID,
       DECODE(JOB_ID,'IT_PROG',SALARY * 0.3,
                     'FI_MGR',SALARY*0.2,
                      SALARY)
FROM EMPLOYEES;

--CASE WHEN THEN ELSE
--1ST
SELECT JOB_ID,
       CASE JOB_ID WHEN 'IT_PROG' THEN SALARY * 0.3
                   WHEN 'FT_MRG' THEN SALARY * 0.2
                   ELSE SALARY
       END
FROM EMPLOYEES;
--2ND
SELECT JOB_ID ,
       CASE WHEN JOB_ID = 'IT_PROG' THEN SALARY * 0.3
            WHEN JOB_ID = 'FI_MRG' THEN SALARY * 0.2
            ELSE SALARY
       END
FROM EMPLOYEES;

--COALESCE(A,B) - NVL이랑 유사 (NULL일 경우에 0으로 치환)
SELECT COALESCE(COMMISSION_PCT,0)FROM EMPLOYEES;

-----------------------------------------
--문제 1.
--현재일자를 기준으로 EMPLOYEE테이블의 입사일자(hire_date)를 참조해서 근속년수가 10년 이상인
--사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성해 보세요. 
--조건 1) 근속년수가 높은 사원 순서대로 결과가 나오도록 합니다
SELECT * FROM EMPLOYEES;
SELECT EMPLOYEE_ID AS 사원번호,
       FIRST_NAME ||' '|| LAST_NAME AS 사원명,
       HIRE_DATE AS 입사일자,
       TRUNC((SYSDATE - HIRE_DATE)/365) AS 근속년수 
FROM EMPLOYEES WHERE TRUNC((SYSDATE - HIRE_DATE)/365)>=10 ORDER BY 근속년수 DESC;
--문제 2.
--EMPLOYEE 테이블의 manager_id컬럼을 확인하여 first_name, manager_id, 직급을 출력합니다.
--100이라면 ‘사원’, 
--120이라면 ‘주임’
--121이라면 ‘대리’
--122라면 ‘과장’
--나머지는 ‘임원’ 으로 출력합니다.
--조건 1) manager_id가 50인 사람들을 대상으로만 조회합니다

SELECT FIRST_NAME, DEPARTMENT_ID,
       MANAGER_ID,
       CASE MANAGER_ID WHEN 100 THEN '사원'
                       WHEN 120 THEN '주임'
                       WHEN 121 THEN '대리'
                       WHEN 122 THEN '과장'
                       ELSE '임원' 
       END AS 직급
FROM EMPLOYEES WHERE DEPARTMENT_ID > 50;









