--INSERT, UPDATE, DELETE ���� �ۼ��ϸ� COMMIT������� ���� �ݿ��� ó���ϴ� �۾��� �ʿ��մϴ�
--INSERT

--���̺� ���� Ȯ��
DESC DEPARTMENTS;

INSERT INTO DEPARTMENTS VALUES(300,'DEV',NULL ,1700); --��ü���� �ִ� ���
INSERT INTO DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME) VALUES(310,'SYSTEM'); -- ���������� �ִ� ���

SELECT * FROM DEPARTMENTS;
ROLLBACK;

--�纻���̺� (���̺� ���� ����)
CREATE TABLE EMPS AS (SELECT * FROM EMPLOYEES WHERE 1 = 2);

INSERT INTO EMPS (SELECT * FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG'); --��ü�÷��� ����
INSERT INTO EMPS (EMPLOYEE_ID,LAST_NAME,EMAIL,HIRE_DATE,JOB_ID)
VALUES(200,
      (SELECT LAST_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = 200),
      (SELECT EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = 200),
      SYSDATE,
      'TEST'
      );
      
SELECT * FROM EMPS;
DESC EMPS;

-------------------------------------------------------
--UPDATE����
SELECT * FROM EMPS;

SELECT * FROM EMPS WHERE EMPLOYEE_ID = 103;

UPDATE EMPS
SET HIRE_DATE = SYSDATE,
    LAST_NAME = 'HONG',
    SALARY = SALARY + 1000
WHERE EMPLOYEE_ID = 103;
--EX2
UPDATE EMPS
SET COMMISSION_PCT = 0.1
WHERE JOB_ID IN ('IT_PROG' , 'SA_MAN');
--EX3 : ID-200�� �޿��� 103���� �����ϰ� ����
UPDATE EMPS
SET SALARY = (SELECT SALARY FROM EMPS WHERE EMPLOYEE_ID = 103)
WHERE EMPLOYEE_ID = 200;
--EX4 : 3���� �÷��� �ѹ��� ����
UPDATE EMPS
SET (JOB_ID , SALARY, COMMISSION_PCT) = (SELECT JOB_ID, SALARY, COMMISSION_PCT FROM EMPS WHERE EMPLOYEE_ID = 103)
WHERE EMPLOYEE_ID = 200;

COMMIT;
---------------------------------------------------------
--DELETE����
CREATE TABLE DEPTS AS (SELECT * FROM DEPARTMENTS WHERE 1 = 1); --���̺� ���� + ������ ����

SELECT * FROM DEPTS;
SELECT * FROM EMPS;
--EX1 - ������ ���� �� PK�� �̿��մϴ�
DELETE FROM EMPS WHERE EMPLOYEE_ID =200;
DELETE FROM EMPS WHERE SALARY >= 4000;
--EX2
DELETE FROM EMPS WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = 'IT');

ROLLBACK;
--
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
--EMPLOYEE�� 60�� �μ��� ����ϰ� �ֱ� ������ �����Ұ� 
DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID = 60;

--MERGE��
--�� ���̺��� ���ؼ� �����Ͱ� ������ UPDATE, ���ٸ� INSERT
SELECT * FROM EMPS;
SELECT * FROM EMPLOYEES WHERE JOB_ID IN ('IT_PROG','SA_MAN');

MERGE INTO EMPS E1
USING (SELECT * FROM EMPLOYEES WHERE JOB_ID IN ('IT_PROG','SA_MAN')) E2
ON (E1.EMPLOYEE_ID = E2.EMPLOYEE_ID)
WHEN MATCHED THEN
    UPDATE SET E1.HIRE_DATE = E2.HIRE_DATE,
               E1.SALARY = E2.SALARY,
               E1.COMMISSION_PCT = E2.COMMISSION_PCT
WHEN NOT MATCHED THEN 
    INSERT VALUES(E2.EMPLOYEE_ID,
                  E2.FIRST_NAME,
                  E2.LAST_NAME,
                  E2.EMAIL,
                  E2.PHONE_NUMBER,
                  E2.JOB_ID,
                  E2.SALARY,
                  E2.COMMISSION_PCT,
                  E2.MANAGER_ID,
                  E2.DEPARTMENT_ID);

--MERGE2
SELECT * FROM EMPS;

MERGE INTO EMPS E
USING DUAL
ON (E.EMPLOYEE_ID = 103) --PK�� ������
WHEN MATCHED THEN
    UPDATE SET LAST_NAME = 'DEMO'
WHEN NOT MATCHED THEN
    INSERT(EMPLOYEE_ID,
           LAST_NAME,
           EMAIL,
           HIRE_DATE,
           JOB_ID) VALUES(1000,'DEMO','DEMO',SYSDATE,'DEMO');
--
DELETE FROM EMPS WHERE EMPLOYEE_ID = 103;

SELECT * FROM EMPS;

------------------------------------------------------------
SELECT * FROM DEPTS;
--��� ������ ������ �� select������ ��ȸ�� Ȯ���� �� commit�մϴ�
--���� 1.
--DEPTS���̺��� ������ �߰��ϼ���

INSERT INTO DEPTS VALUES (280,'����',NULL,1800);
INSERT INTO DEPTS VALUES (290,'ȸ���',NULL,1800);
INSERT INTO DEPTS VALUES (300,'����',301,1800);
INSERT INTO DEPTS VALUES (310,'�λ�',302,1800);
INSERT INTO DEPTS VALUES (320,'����',303,1700);


DELETE FROM DEPTS WHERE DEPARTMENT_ID =280;
DELETE FROM DEPTS WHERE DEPARTMENT_ID =290;
DELETE FROM DEPTS WHERE DEPARTMENT_ID =320;
--���� 2.
--DEPTS���̺��� �����͸� �����մϴ�
--1. department_name �� IT Support �� �������� department_name�� IT bank�� ����
UPDATE DEPTS
SET DEPARTMENT_NAME = 'IT_BANK'
WHERE DEPARTMENT_ID = 210;
SELECT * FROM DEPTS;
--2. department_id�� 290�� �������� manager_id�� 301�� ����
UPDATE DEPTS
SET MANAGER_ID = 301
WHERE DEPARTMENT_ID = 290;
--3. department_name�� IT Helpdesk�� �������� �μ����� IT Help�� , �Ŵ������̵� 303����, �������̵�
--1800���� �����ϼ���
UPDATE DEPTS
SET DEPARTMENT_NAME = 'IT Help',
    MANAGER_ID = 303,
    LOCATION_ID = 1800
WHERE DEPARTMENT_NAME = 'IT Helpdesk';
--4. ����,�λ�,���� �� �Ŵ������̵� 301�� �ѹ��� �����ϼ���.

UPDATE DEPTS
SET MANAGER_ID = 301
WHERE DEPARTMENT_NAME IN ('����','�λ�','����'); 
COMMIT;

SELECT * FROM DEPTS;
--���� 3.
--������ ������ �׻� primary key�� �մϴ�, ���⼭ primary key�� department_id��� �����մϴ�.
--1. �μ��� �����θ� ���� �ϼ���
DELETE FROM DEPTS WHERE DEPARTMENT_ID = 320;
--2. �μ��� NOC�� �����ϼ���
DELETE FROM DEPTS WHERE DEPARTMENT_ID = 220;

--����4
--1. Depts �纻���̺��� department_id �� 200���� ū �����͸� �����ϼ���.
DELETE FROM DEPTS WHERE DEPARTMENT_ID >= 200;
--2. Depts �纻���̺��� manager_id�� null�� �ƴ� �������� manager_id�� ���� 100���� �����ϼ���.
UPDATE DEPTS SET MANAGER_ID = 100 WHERE MANAGER_ID IS NOT NULL;
--3. Depts ���̺��� Ÿ�� ���̺� �Դϴ�.
--4. Departments���̺��� �Ź� ������ �Ͼ�� ���̺��̶�� �����ϰ� Depts�� ���Ͽ�
--��ġ�ϴ� ��� Depts�� �μ���, �Ŵ���ID, ����ID�� ������Ʈ �ϰ�
--�������Ե� �����ʹ� �״�� �߰����ִ� merge���� �ۼ��ϼ���.
MERGE INTO Depts D1
USING (SELECT * FROM DEPARTMENTS) D2
ON (D1.DEPARTMENT_ID = D2.DEPARTMENT_ID)
WHEN MATCHED THEN
    UPDATE SET D1.DEPARTMENT_NAME = D2.DEPARTMENT_NAME,
               D1.MANAGER_ID = D2.MANAGER_ID,
               D1.LOCATION_ID = D2.LOCATION_ID
WHEN NOT MATCHED THEN
    INSERT VALUES (D2.DEPARTMENT_ID , D2.DEPARTMENT_NAME , D2.MANAGER_ID,D2.LOCATION_ID);
    
DESC DEPTS;
--���� 5
--1. jobs_it �纻 ���̺��� �����ϼ��� (������ min_salary�� 6000���� ū �����͸� �����մϴ�)
--2. jobs_it ���̺� ���� �����͸� �߰��ϼ���
--3. jobs_it�� Ÿ�� ���̺� �Դϴ�
--4. jobs���̺��� �Ź� ������ �Ͼ�� ���̺��̶�� �����ϰ� jobs_it�� ���Ͽ�
--min_salary�÷��� 0���� ū ��� ������ �����ʹ� min_salary, max_salary�� ������Ʈ �ϰ� ���� ���Ե�
--�����ʹ� �״�� �߰����ִ� merge���� �ۼ��ϼ���

CREATE TABLE JOBS_IT AS (SELECT * FROM JOBS WHERE MIN_SALARY >= 6000 AND 1=1);
SELECT * FROM JOBS_IT;

INSERT INTO JOBS_IT VALUES ('IT_DEV' , '����Ƽ������' , 6000,20000);
INSERT INTO JOBS_IT VALUES ('NET_DEV' , '��Ʈ��ũ������' , 5000,20000);
INSERT INTO JOBS_IT VALUES ('SEC_DEV' , '���Ȱ�����' , 6000,19000);

MERGE INTO JOBS_IT J1
USING(SELECT * FROM JOBS WHERE MIN_SALARY >= 0) J2
ON (J1.JOB_ID = J2.JOB_ID)
WHEN MATCHED THEN
    UPDATE SET J1.MIN_SALARY = J2.MIN_SALARY,
               J1.MAX_SALARY = J2.MAX_SALARY
WHEN NOT MATCHED THEN
    INSERT VALUES (J2.JOB_ID,J2.JOB_TITLE,J2.MIN_SALARY,J2.MAX_SALARY);
    
SELECT * FROM JOBS_IT;   









