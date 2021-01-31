--------------------------------------------------------
--  File created - Pátek-dubna-27-2018   
--------------------------------------------------------




create or replace procedure SMAZ_VSECHNY_TABULKY AS
-- pokud v logu bude uvedeno, ze nektery objekt nebyl zrusen, protoze na nej jiny jeste existujici objekt stavi, spust proceduru opakovane, dokud se nezrusi vse
begin
  for iRec in 
    (select distinct OBJECT_TYPE, OBJECT_NAME,
      'drop '||OBJECT_TYPE||' "'||OBJECT_NAME||'"'||
      case OBJECT_TYPE when 'TABLE' then ' cascade constraints purge' else ' ' end as PRIKAZ
    from USER_OBJECTS where OBJECT_NAME not in ('SMAZ_VSECHNY_TABULKY', 'VYPNI_CIZI_KLICE', 'ZAPNI_CIZI_KLICE', 'VYMAZ_DATA_VSECH_TABULEK')
    ) loop
        begin
          dbms_output.put_line('Prikaz: '||irec.prikaz);
        execute immediate iRec.prikaz;
        exception
          when others then dbms_output.put_line('NEPOVEDLO SE!');
        end;
      end loop;
end;
/



create or replace procedure VYPNI_CIZI_KLICE as 
begin
  for cur in (select CONSTRAINT_NAME, TABLE_NAME from USER_CONSTRAINTS where CONSTRAINT_TYPE = 'R' ) 
  loop
    execute immediate 'alter table '||cur.TABLE_NAME||' modify constraint "'||cur.CONSTRAINT_NAME||'" DISABLE';
  end loop;
end VYPNI_CIZI_KLICE;
/


create or replace procedure ZAPNI_CIZI_KLICE as 
begin
  for cur in (select CONSTRAINT_NAME, TABLE_NAME from USER_CONSTRAINTS where CONSTRAINT_TYPE = 'R' ) 
  loop
    execute immediate 'alter table '||cur.TABLE_NAME||' modify constraint "'||cur.CONSTRAINT_NAME||'" enable validate';
  end loop;
end ZAPNI_CIZI_KLICE;
/



create or replace procedure VYMAZ_DATA_VSECH_TABULEK is
begin
  -- Vymazat data vsech tabulek
  VYPNI_CIZI_KLICE;
  for v_rec in (select distinct TABLE_NAME from USER_TABLES)
  loop
    execute immediate 'truncate table '||v_rec.TABLE_NAME||' drop storage';
  end loop;
  ZAPNI_CIZI_KLICE;
  
  -- Nastavit vsechny sekvence od 1
  for v_rec in (select distinct SEQUENCE_NAME  from USER_SEQUENCES)
  loop
    execute immediate 'alter sequence '||v_rec.SEQUENCE_NAME||' restart start with 1';
  end loop;
end VYMAZ_DATA_VSECH_TABULEK;
/

exec SMAZ_VSECHNY_TABULKY;







--------------------------------------------------------
--  DDL for Table ADRESA
--------------------------------------------------------

  CREATE TABLE "ADRESA" 
   (	"ADRESA_KEY" NUMBER(*,0), 
	"CISLO_POPISNE" NUMBER(*,0), 
	"ULICE" VARCHAR2(20 CHAR), 
	"MESTO" VARCHAR2(20 CHAR)
   ) ;
--------------------------------------------------------
--  DDL for Table FAMFRPALOVY_TYM
--------------------------------------------------------

  CREATE TABLE "FAMFRPALOVY_TYM" 
   (	"PREZDIVKA" VARCHAR2(10 CHAR), 
	"KOLEJ_NAZEV_KOLEJE" VARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table FAMFRPALT
--------------------------------------------------------

  CREATE TABLE "FAMFRPALT" 
   (	"PREZDIVKA" VARCHAR2(10 CHAR), 
	"KOLEJ_NAZEV_KOLEJE" VARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table HRAC
--------------------------------------------------------

  CREATE TABLE "HRAC" 
   (	"CISLO" NUMBER(*,0), 
	"POZICE" VARCHAR2(15 CHAR), 
	"KOSTE" VARCHAR2(15 CHAR), 
	"STUDENT_ID_STUDENT" NUMBER(*,0), 
	"FAMFRPALT_KOLEJ_NAZEV_KOLEJE" VARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table KOLEJ
--------------------------------------------------------

  CREATE TABLE "KOLEJ" 
   (	"NAZEV_KOLEJE" VARCHAR2(20), 
	"BARVA" VARCHAR2(20), 
	"PATRON" VARCHAR2(20), 
	"ZKRATKA_KOLEJE" VARCHAR2(10), 
	"UCITEL_ID_ZAMESTNANEC" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table OSTATNI
--------------------------------------------------------

  CREATE TABLE "OSTATNI" 
   (	"POZICE" VARCHAR2(20 CHAR), 
	"ZAMESTNANEC_ID_ZAMESTNANEC" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table POVINNE_VOLITELNY
--------------------------------------------------------

  CREATE TABLE "POVINNE_VOLITELNY" 
   (	"NAZEV" VARCHAR2(50 CHAR), 
	"ZKRATKA" VARCHAR2(10 CHAR), 
	"POVINNE_VOLITELNY_TYPE" VARCHAR2(17)
   ) ;
--------------------------------------------------------
--  DDL for Table POVINNY
--------------------------------------------------------

  CREATE TABLE "POVINNY" 
   (	"NAZEV" VARCHAR2(50 CHAR), 
	"PRUCHODNOST" NUMBER(*,0), 
	"POVINNY_TYPE" VARCHAR2(7)
   ) ;
--------------------------------------------------------
--  DDL for Table PREDMET
--------------------------------------------------------

  CREATE TABLE "PREDMET" 
   (	"NAZEV" VARCHAR2(50 CHAR), 
	"UCITEL_ZAMESTNANEC_ID_ZAM" NUMBER, 
	"PREDMET_TYPE" VARCHAR2(17)
   ) ;
--------------------------------------------------------
--  DDL for Table PREDMET_V_ROCNIKU
--------------------------------------------------------

  CREATE TABLE "PREDMET_V_ROCNIKU" 
   (	"ROCNIK_ID_ROCNIK" NUMBER(*,0), 
	"POVINNY_NAZEV" VARCHAR2(50 CHAR)
   ) ;
--------------------------------------------------------
--  DDL for Table PREFEKT
--------------------------------------------------------

  CREATE TABLE "PREFEKT" 
   (	"PRUMER_ZNAMEK" NUMBER, 
	"STUDENT_ID_STUDENT" NUMBER(*,0)
   ) ;
--------------------------------------------------------
--  DDL for Table PRIMUS
--------------------------------------------------------

  CREATE TABLE "PRIMUS" 
   (	"PREZDIVKA" VARCHAR2(20 CHAR), 
	"PREFEKT_STUDENT_ID_STUDENT" NUMBER(*,0)
   ) ;
--------------------------------------------------------
--  DDL for Table REDITEL
--------------------------------------------------------

  CREATE TABLE "REDITEL" 
   (	"KOUZELNICKY_TITUL" VARCHAR2(50 CHAR), 
	"ZAMESTNANEC_ID_ZAMESTNANEC" NUMBER
   ) ;
--------------------------------------------------------
--  DDL for Table ROCNIK
--------------------------------------------------------

  CREATE TABLE "ROCNIK" 
   (	"ID_ROCNIK" NUMBER(*,0)
   ) ;
--------------------------------------------------------
--  DDL for Table STUDENT
--------------------------------------------------------

  CREATE TABLE "STUDENT" 
   (	"ID_STUDENT" NUMBER(*,0), 
	"JMENO" VARCHAR2(20 CHAR), 
	"PRIJMENI" VARCHAR2(20 CHAR), 
	"ROK_NAROZENI" NUMBER(*,0), 
	"HULKA" VARCHAR2(30 CHAR), 
	"SOVA" VARCHAR2(30 CHAR), 
	"ADRESA_ADRESA_KEY" NUMBER(*,0), 
	"ROCNIK_ID_ROCNIK" NUMBER(*,0), 
	"KOLEJ_NAZEV_KOLEJE" VARCHAR2(20)
   ) ;
--------------------------------------------------------
--  DDL for Table STUDUJE
--------------------------------------------------------

  CREATE TABLE "STUDUJE" 
   (	"POVINNE_VOLITELNY_NAZEV" VARCHAR2(50 CHAR), 
	"STUDENT_ID_STUDENT" NUMBER(*,0)
   ) ;
--------------------------------------------------------
--  DDL for Table UCITEL
--------------------------------------------------------

  CREATE TABLE "UCITEL" 
   (	"KOUZELNICKY_TITUL" VARCHAR2(50 CHAR), 
	"PREDMET_NAZEV" VARCHAR2(50 CHAR), 
	"ZAMESTNANEC_ID_ZAMESTNANEC" NUMBER, 
	"ZASTUPCE_REDITELE" CHAR(1)
   ) ;
--------------------------------------------------------
--  DDL for Table ZAMESTNANEC
--------------------------------------------------------

  CREATE TABLE "ZAMESTNANEC" 
   (	"ID_ZAMESTNANEC" NUMBER, 
	"JMENO" VARCHAR2(20 CHAR), 
	"PRIJMENI" VARCHAR2(20 CHAR), 
	"ROK_NAROZENI" NUMBER(*,0), 
	"VYSE_PLATU" NUMBER, 
	"ADRESA_ADRESA_KEY" NUMBER(*,0)
   ) ;
--------------------------------------------------------
--  DDL for Index ZAMESTNANEC_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "ZAMESTNANEC_PK" ON "ZAMESTNANEC" ("ID_ZAMESTNANEC") 
  ;
--------------------------------------------------------
--  DDL for Index UCITEL_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "UCITEL_PK" ON "UCITEL" ("ZAMESTNANEC_ID_ZAMESTNANEC") 
  ;
--------------------------------------------------------
--  DDL for Index STUDUJE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "STUDUJE_PK" ON "STUDUJE" ("POVINNE_VOLITELNY_NAZEV", "STUDENT_ID_STUDENT") 
  ;
--------------------------------------------------------
--  DDL for Index STUDENT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "STUDENT_PK" ON "STUDENT" ("ID_STUDENT") 
  ;
--------------------------------------------------------
--  DDL for Index ROCNIK_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "ROCNIK_PK" ON "ROCNIK" ("ID_ROCNIK") 
  ;
--------------------------------------------------------
--  DDL for Index REDITEL_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "REDITEL_PK" ON "REDITEL" ("ZAMESTNANEC_ID_ZAMESTNANEC") 
  ;
--------------------------------------------------------
--  DDL for Index PRIMUS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PRIMUS_PK" ON "PRIMUS" ("PREFEKT_STUDENT_ID_STUDENT") 
  ;
--------------------------------------------------------
--  DDL for Index PREFEKT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PREFEKT_PK" ON "PREFEKT" ("STUDENT_ID_STUDENT") 
  ;
--------------------------------------------------------
--  DDL for Index PREDMET_V_ROCNIKU_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PREDMET_V_ROCNIKU_PK" ON "PREDMET_V_ROCNIKU" ("ROCNIK_ID_ROCNIK", "POVINNY_NAZEV") 
  ;
--------------------------------------------------------
--  DDL for Index PREDMET_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "PREDMET_PK" ON "PREDMET" ("NAZEV") 
  ;
--------------------------------------------------------
--  DDL for Index POVINNY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "POVINNY_PK" ON "POVINNY" ("NAZEV") 
  ;
--------------------------------------------------------
--  DDL for Index POVINNE_VOLITELNY_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "POVINNE_VOLITELNY_PK" ON "POVINNE_VOLITELNY" ("NAZEV") 
  ;
--------------------------------------------------------
--  DDL for Index OSTATNI_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "OSTATNI_PK" ON "OSTATNI" ("ZAMESTNANEC_ID_ZAMESTNANEC") 
  ;
--------------------------------------------------------
--  DDL for Index KOLEJ_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "KOLEJ_PK" ON "KOLEJ" ("NAZEV_KOLEJE") 
  ;
--------------------------------------------------------
--  DDL for Index HRAC_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HRAC_PK" ON "HRAC" ("STUDENT_ID_STUDENT") 
  ;
--------------------------------------------------------
--  DDL for Index FAMFRPALT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "FAMFRPALT_PK" ON "FAMFRPALT" ("KOLEJ_NAZEV_KOLEJE") 
  ;
--------------------------------------------------------
--  DDL for Index FAMFRPALOVY_TYM_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "FAMFRPALOVY_TYM_PK" ON "FAMFRPALOVY_TYM" ("KOLEJ_NAZEV_KOLEJE") 
  ;
--------------------------------------------------------
--  DDL for Index ADRESA_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "ADRESA_PK" ON "ADRESA" ("ADRESA_KEY") 
  ;
--------------------------------------------------------
--  DDL for Index PREDMET__IDX
--------------------------------------------------------

  CREATE UNIQUE INDEX "PREDMET__IDX" ON "PREDMET" ("UCITEL_ZAMESTNANEC_ID_ZAM") 
  ;
--------------------------------------------------------
--  DDL for Index KOLEJ__IDX
--------------------------------------------------------

  CREATE UNIQUE INDEX "KOLEJ__IDX" ON "KOLEJ" ("UCITEL_ID_ZAMESTNANEC") 
  ;
--------------------------------------------------------
--  DDL for Index UCITEL__IDX
--------------------------------------------------------

  CREATE UNIQUE INDEX "UCITEL__IDX" ON "UCITEL" ("PREDMET_NAZEV") 
  ;
--------------------------------------------------------
--  DDL for Trigger ARC_FKARC_1_POVINNE_VOLITELNY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "ARC_FKARC_1_POVINNE_VOLITELNY" BEFORE
    INSERT OR UPDATE OF nazev ON povinne_volitelny
    FOR EACH ROW
DECLARE
    d   VARCHAR2(17);
BEGIN
    SELECT
        a.predmet_type
    INTO
        d
    FROM
        predmet a
    WHERE
        a.nazev =:new.nazev;

    IF
        ( d IS NULL OR d <> 'Povinne_volitelny' )
    THEN
        raise_application_error(-20223,'FK Povinne_volitelny_Predmet_FK in Table Povinne_volitelny violates Arc constraint on Table Predmet - discriminator column Predmet_TYPE doesn''t have value ''Povinne_volitelny'''
);
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/
ALTER TRIGGER "ARC_FKARC_1_POVINNE_VOLITELNY" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ARC_FKARC_1_POVINNY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "ARC_FKARC_1_POVINNY" BEFORE
    INSERT OR UPDATE OF nazev ON povinny
    FOR EACH ROW
DECLARE
    d   VARCHAR2(17);
BEGIN
    SELECT
        a.predmet_type
    INTO
        d
    FROM
        predmet a
    WHERE
        a.nazev =:new.nazev;

    IF
        ( d IS NULL OR d <> 'Povinny' )
    THEN
        raise_application_error(-20223,'FK Povinny_Predmet_FK in Table Povinny violates Arc constraint on Table Predmet - discriminator column Predmet_TYPE doesn''t have value ''Povinny'''
);
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/
ALTER TRIGGER "ARC_FKARC_1_POVINNY" ENABLE;
--------------------------------------------------------
--  DDL for Procedure SMAZ_VSECHNY_TABULKY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "SMAZ_VSECHNY_TABULKY" AS
-- pokud v logu bude uvedeno, ze nektery objekt nebyl zrusen, protoze na nej jiny jeste existujici objekt stavi, spust proceduru opakovane, dokud se nezrusi vse
begin
  for iRec in 
    (select distinct OBJECT_TYPE, OBJECT_NAME,
      'drop '||OBJECT_TYPE||' "'||OBJECT_NAME||'"'||
      case OBJECT_TYPE when 'TABLE' then ' cascade constraints purge' else ' ' end as PRIKAZ
    from USER_OBJECTS where OBJECT_NAME not in ('SMAZ_VSECHNY_TABULKY', 'VYPNI_CIZI_KLICE', 'ZAPNI_CIZI_KLICE', 'VYMAZ_DATA_VSECH_TABULEK')
    ) loop
        begin
          dbms_output.put_line('Prikaz: '||irec.prikaz);
        execute immediate iRec.prikaz;
        exception
          when others then dbms_output.put_line('NEPOVEDLO SE!');
        end;
      end loop;
end;

/
--------------------------------------------------------
--  DDL for Procedure VYMAZ_DATA_VSECH_TABULEK
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "VYMAZ_DATA_VSECH_TABULEK" is
begin
  -- Vymazat data vsech tabulek
  VYPNI_CIZI_KLICE;
  for v_rec in (select distinct TABLE_NAME from USER_TABLES)
  loop
    execute immediate 'truncate table '||v_rec.TABLE_NAME||' drop storage';
  end loop;
  ZAPNI_CIZI_KLICE;

  -- Nastavit vsechny sekvence od 1
  for v_rec in (select distinct SEQUENCE_NAME  from USER_SEQUENCES)
  loop
    execute immediate 'alter sequence '||v_rec.SEQUENCE_NAME||' restart start with 1';
  end loop;
end VYMAZ_DATA_VSECH_TABULEK;

/
--------------------------------------------------------
--  DDL for Procedure VYPNI_CIZI_KLICE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "VYPNI_CIZI_KLICE" as 
begin
  for cur in (select CONSTRAINT_NAME, TABLE_NAME from USER_CONSTRAINTS where CONSTRAINT_TYPE = 'R' ) 
  loop
    execute immediate 'alter table '||cur.TABLE_NAME||' modify constraint "'||cur.CONSTRAINT_NAME||'" DISABLE';
  end loop;
end VYPNI_CIZI_KLICE;

/
--------------------------------------------------------
--  DDL for Procedure ZAPNI_CIZI_KLICE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "ZAPNI_CIZI_KLICE" as 
begin
  for cur in (select CONSTRAINT_NAME, TABLE_NAME from USER_CONSTRAINTS where CONSTRAINT_TYPE = 'R' ) 
  loop
    execute immediate 'alter table '||cur.TABLE_NAME||' modify constraint "'||cur.CONSTRAINT_NAME||'" enable validate';
  end loop;
end ZAPNI_CIZI_KLICE;

/
--------------------------------------------------------
--  Constraints for Table OSTATNI
--------------------------------------------------------

  ALTER TABLE "OSTATNI" ADD CONSTRAINT "OSTATNI_PK" PRIMARY KEY ("ZAMESTNANEC_ID_ZAMESTNANEC")
  USING INDEX  ENABLE;
  ALTER TABLE "OSTATNI" MODIFY ("POZICE" NOT NULL ENABLE);
  ALTER TABLE "OSTATNI" MODIFY ("ZAMESTNANEC_ID_ZAMESTNANEC" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table FAMFRPALT
--------------------------------------------------------

  ALTER TABLE "FAMFRPALT" ADD CONSTRAINT "FAMFRPALT_PK" PRIMARY KEY ("KOLEJ_NAZEV_KOLEJE")
  USING INDEX  ENABLE;
  ALTER TABLE "FAMFRPALT" MODIFY ("KOLEJ_NAZEV_KOLEJE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ZAMESTNANEC
--------------------------------------------------------

  ALTER TABLE "ZAMESTNANEC" MODIFY ("ID_ZAMESTNANEC" NOT NULL ENABLE);
  ALTER TABLE "ZAMESTNANEC" MODIFY ("JMENO" NOT NULL ENABLE);
  ALTER TABLE "ZAMESTNANEC" MODIFY ("PRIJMENI" NOT NULL ENABLE);
  ALTER TABLE "ZAMESTNANEC" MODIFY ("ROK_NAROZENI" NOT NULL ENABLE);
  ALTER TABLE "ZAMESTNANEC" MODIFY ("ADRESA_ADRESA_KEY" NOT NULL ENABLE);
  ALTER TABLE "ZAMESTNANEC" ADD CONSTRAINT "ZAMESTNANEC_PK" PRIMARY KEY ("ID_ZAMESTNANEC")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table KOLEJ
--------------------------------------------------------

  ALTER TABLE "KOLEJ" ADD CONSTRAINT "KOLEJ_PK" PRIMARY KEY ("NAZEV_KOLEJE")
  USING INDEX  ENABLE;
  ALTER TABLE "KOLEJ" MODIFY ("NAZEV_KOLEJE" NOT NULL ENABLE);
  ALTER TABLE "KOLEJ" MODIFY ("BARVA" NOT NULL ENABLE);
  ALTER TABLE "KOLEJ" MODIFY ("PATRON" NOT NULL ENABLE);
  ALTER TABLE "KOLEJ" MODIFY ("UCITEL_ID_ZAMESTNANEC" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table POVINNY
--------------------------------------------------------

  ALTER TABLE "POVINNY" ADD CONSTRAINT "CH_INH_POVINNY" CHECK ( povinny_type IN (
        'Povinny'
    ) ) ENABLE;
  ALTER TABLE "POVINNY" ADD CONSTRAINT "POVINNY_PK" PRIMARY KEY ("NAZEV")
  USING INDEX  ENABLE;
  ALTER TABLE "POVINNY" MODIFY ("NAZEV" NOT NULL ENABLE);
  ALTER TABLE "POVINNY" MODIFY ("PRUCHODNOST" NOT NULL ENABLE);
  ALTER TABLE "POVINNY" MODIFY ("POVINNY_TYPE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PREDMET_V_ROCNIKU
--------------------------------------------------------

  ALTER TABLE "PREDMET_V_ROCNIKU" ADD CONSTRAINT "PREDMET_V_ROCNIKU_PK" PRIMARY KEY ("ROCNIK_ID_ROCNIK", "POVINNY_NAZEV")
  USING INDEX  ENABLE;
  ALTER TABLE "PREDMET_V_ROCNIKU" MODIFY ("ROCNIK_ID_ROCNIK" NOT NULL ENABLE);
  ALTER TABLE "PREDMET_V_ROCNIKU" MODIFY ("POVINNY_NAZEV" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PREFEKT
--------------------------------------------------------

  ALTER TABLE "PREFEKT" ADD CONSTRAINT "PREFEKT_PK" PRIMARY KEY ("STUDENT_ID_STUDENT")
  USING INDEX  ENABLE;
  ALTER TABLE "PREFEKT" MODIFY ("STUDENT_ID_STUDENT" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PRIMUS
--------------------------------------------------------

  ALTER TABLE "PRIMUS" ADD CONSTRAINT "PRIMUS_PK" PRIMARY KEY ("PREFEKT_STUDENT_ID_STUDENT")
  USING INDEX  ENABLE;
  ALTER TABLE "PRIMUS" MODIFY ("PREFEKT_STUDENT_ID_STUDENT" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ROCNIK
--------------------------------------------------------

  ALTER TABLE "ROCNIK" ADD CONSTRAINT "ROCNIK_PK" PRIMARY KEY ("ID_ROCNIK")
  USING INDEX  ENABLE;
  ALTER TABLE "ROCNIK" MODIFY ("ID_ROCNIK" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table REDITEL
--------------------------------------------------------

  ALTER TABLE "REDITEL" ADD CONSTRAINT "REDITEL_PK" PRIMARY KEY ("ZAMESTNANEC_ID_ZAMESTNANEC")
  USING INDEX  ENABLE;
  ALTER TABLE "REDITEL" MODIFY ("KOUZELNICKY_TITUL" NOT NULL ENABLE);
  ALTER TABLE "REDITEL" MODIFY ("ZAMESTNANEC_ID_ZAMESTNANEC" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table FAMFRPALOVY_TYM
--------------------------------------------------------

  ALTER TABLE "FAMFRPALOVY_TYM" ADD CONSTRAINT "FAMFRPALOVY_TYM_PK" PRIMARY KEY ("KOLEJ_NAZEV_KOLEJE")
  USING INDEX  ENABLE;
  ALTER TABLE "FAMFRPALOVY_TYM" MODIFY ("KOLEJ_NAZEV_KOLEJE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table UCITEL
--------------------------------------------------------

  ALTER TABLE "UCITEL" MODIFY ("KOUZELNICKY_TITUL" NOT NULL ENABLE);
  ALTER TABLE "UCITEL" MODIFY ("PREDMET_NAZEV" NOT NULL ENABLE);
  ALTER TABLE "UCITEL" MODIFY ("ZAMESTNANEC_ID_ZAMESTNANEC" NOT NULL ENABLE);
  ALTER TABLE "UCITEL" MODIFY ("ZASTUPCE_REDITELE" NOT NULL ENABLE);
  ALTER TABLE "UCITEL" ADD CONSTRAINT "UCITEL_PK" PRIMARY KEY ("ZAMESTNANEC_ID_ZAMESTNANEC")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table HRAC
--------------------------------------------------------

  ALTER TABLE "HRAC" ADD CONSTRAINT "HRAC_PK" PRIMARY KEY ("STUDENT_ID_STUDENT")
  USING INDEX  ENABLE;
  ALTER TABLE "HRAC" MODIFY ("CISLO" NOT NULL ENABLE);
  ALTER TABLE "HRAC" MODIFY ("POZICE" NOT NULL ENABLE);
  ALTER TABLE "HRAC" MODIFY ("STUDENT_ID_STUDENT" NOT NULL ENABLE);
  ALTER TABLE "HRAC" MODIFY ("FAMFRPALT_KOLEJ_NAZEV_KOLEJE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ADRESA
--------------------------------------------------------

  ALTER TABLE "ADRESA" ADD CONSTRAINT "ADRESA_PK" PRIMARY KEY ("ADRESA_KEY")
  USING INDEX  ENABLE;
  ALTER TABLE "ADRESA" MODIFY ("ADRESA_KEY" NOT NULL ENABLE);
  ALTER TABLE "ADRESA" MODIFY ("CISLO_POPISNE" NOT NULL ENABLE);
  ALTER TABLE "ADRESA" MODIFY ("MESTO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table STUDUJE
--------------------------------------------------------

  ALTER TABLE "STUDUJE" ADD CONSTRAINT "STUDUJE_PK" PRIMARY KEY ("POVINNE_VOLITELNY_NAZEV", "STUDENT_ID_STUDENT")
  USING INDEX  ENABLE;
  ALTER TABLE "STUDUJE" MODIFY ("POVINNE_VOLITELNY_NAZEV" NOT NULL ENABLE);
  ALTER TABLE "STUDUJE" MODIFY ("STUDENT_ID_STUDENT" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PREDMET
--------------------------------------------------------

  ALTER TABLE "PREDMET" ADD CONSTRAINT "CH_INH_PREDMET" CHECK ( predmet_type IN (
        'Povinne_volitelny',
        'Povinny',
        'Predmet'
    ) ) ENABLE;
  ALTER TABLE "PREDMET" ADD CONSTRAINT "PREDMET_PK" PRIMARY KEY ("NAZEV")
  USING INDEX  ENABLE;
  ALTER TABLE "PREDMET" MODIFY ("NAZEV" NOT NULL ENABLE);
  ALTER TABLE "PREDMET" MODIFY ("UCITEL_ZAMESTNANEC_ID_ZAM" NOT NULL ENABLE);
  ALTER TABLE "PREDMET" MODIFY ("PREDMET_TYPE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table POVINNE_VOLITELNY
--------------------------------------------------------

  ALTER TABLE "POVINNE_VOLITELNY" ADD CONSTRAINT "CH_INH_POVINNE_VOLITELNY" CHECK ( povinne_volitelny_type IN (
        'Povinne_volitelny'
    ) ) ENABLE;
  ALTER TABLE "POVINNE_VOLITELNY" ADD CONSTRAINT "POVINNE_VOLITELNY_PK" PRIMARY KEY ("NAZEV")
  USING INDEX  ENABLE;
  ALTER TABLE "POVINNE_VOLITELNY" MODIFY ("NAZEV" NOT NULL ENABLE);
  ALTER TABLE "POVINNE_VOLITELNY" MODIFY ("ZKRATKA" NOT NULL ENABLE);
  ALTER TABLE "POVINNE_VOLITELNY" MODIFY ("POVINNE_VOLITELNY_TYPE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table STUDENT
--------------------------------------------------------

  ALTER TABLE "STUDENT" ADD CONSTRAINT "STUDENT_PK" PRIMARY KEY ("ID_STUDENT")
  USING INDEX  ENABLE;
  ALTER TABLE "STUDENT" MODIFY ("ID_STUDENT" NOT NULL ENABLE);
  ALTER TABLE "STUDENT" MODIFY ("JMENO" NOT NULL ENABLE);
  ALTER TABLE "STUDENT" MODIFY ("PRIJMENI" NOT NULL ENABLE);
  ALTER TABLE "STUDENT" MODIFY ("ROK_NAROZENI" NOT NULL ENABLE);
  ALTER TABLE "STUDENT" MODIFY ("ADRESA_ADRESA_KEY" NOT NULL ENABLE);
  ALTER TABLE "STUDENT" MODIFY ("ROCNIK_ID_ROCNIK" NOT NULL ENABLE);
  ALTER TABLE "STUDENT" MODIFY ("KOLEJ_NAZEV_KOLEJE" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table FAMFRPALOVY_TYM
--------------------------------------------------------

  ALTER TABLE "FAMFRPALOVY_TYM" ADD CONSTRAINT "FAMFRPALOVY_TYM_KOLEJ_FK" FOREIGN KEY ("KOLEJ_NAZEV_KOLEJE")
	  REFERENCES "KOLEJ" ("NAZEV_KOLEJE") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table FAMFRPALT
--------------------------------------------------------

  ALTER TABLE "FAMFRPALT" ADD CONSTRAINT "FAMFRPALT_KOLEJ_FK" FOREIGN KEY ("KOLEJ_NAZEV_KOLEJE")
	  REFERENCES "KOLEJ" ("NAZEV_KOLEJE") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table HRAC
--------------------------------------------------------

  ALTER TABLE "HRAC" ADD CONSTRAINT "HRAC_FAMFRPALT_FK" FOREIGN KEY ("FAMFRPALT_KOLEJ_NAZEV_KOLEJE")
	  REFERENCES "FAMFRPALT" ("KOLEJ_NAZEV_KOLEJE") ENABLE;
  ALTER TABLE "HRAC" ADD CONSTRAINT "HRAC_STUDENT_FK" FOREIGN KEY ("STUDENT_ID_STUDENT")
	  REFERENCES "STUDENT" ("ID_STUDENT") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table KOLEJ
--------------------------------------------------------

  ALTER TABLE "KOLEJ" ADD CONSTRAINT "KOLEJ_UCITEL_FK" FOREIGN KEY ("UCITEL_ID_ZAMESTNANEC")
	  REFERENCES "UCITEL" ("ZAMESTNANEC_ID_ZAMESTNANEC") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table OSTATNI
--------------------------------------------------------

  ALTER TABLE "OSTATNI" ADD CONSTRAINT "OSTATNI_ZAMESTNANEC_FK" FOREIGN KEY ("ZAMESTNANEC_ID_ZAMESTNANEC")
	  REFERENCES "ZAMESTNANEC" ("ID_ZAMESTNANEC") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table POVINNE_VOLITELNY
--------------------------------------------------------

  ALTER TABLE "POVINNE_VOLITELNY" ADD CONSTRAINT "POVINNE_VOLITELNY_PREDMET_FK" FOREIGN KEY ("NAZEV")
	  REFERENCES "PREDMET" ("NAZEV") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table POVINNY
--------------------------------------------------------

  ALTER TABLE "POVINNY" ADD CONSTRAINT "POVINNY_PREDMET_FK" FOREIGN KEY ("NAZEV")
	  REFERENCES "PREDMET" ("NAZEV") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PREDMET_V_ROCNIKU
--------------------------------------------------------

  ALTER TABLE "PREDMET_V_ROCNIKU" ADD CONSTRAINT "PREDMET_V_ROCNIKU_POVINNY_FK" FOREIGN KEY ("POVINNY_NAZEV")
	  REFERENCES "POVINNY" ("NAZEV") ENABLE;
  ALTER TABLE "PREDMET_V_ROCNIKU" ADD CONSTRAINT "PREDMET_V_ROCNIKU_ROCNIK_FK" FOREIGN KEY ("ROCNIK_ID_ROCNIK")
	  REFERENCES "ROCNIK" ("ID_ROCNIK") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PREFEKT
--------------------------------------------------------

  ALTER TABLE "PREFEKT" ADD CONSTRAINT "PREFEKT_STUDENT_FK" FOREIGN KEY ("STUDENT_ID_STUDENT")
	  REFERENCES "STUDENT" ("ID_STUDENT") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PRIMUS
--------------------------------------------------------

  ALTER TABLE "PRIMUS" ADD CONSTRAINT "PRIMUS_PREFEKT_FK" FOREIGN KEY ("PREFEKT_STUDENT_ID_STUDENT")
	  REFERENCES "PREFEKT" ("STUDENT_ID_STUDENT") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table REDITEL
--------------------------------------------------------

  ALTER TABLE "REDITEL" ADD CONSTRAINT "REDITEL_ZAMESTNANEC_FK" FOREIGN KEY ("ZAMESTNANEC_ID_ZAMESTNANEC")
	  REFERENCES "ZAMESTNANEC" ("ID_ZAMESTNANEC") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table STUDENT
--------------------------------------------------------

  ALTER TABLE "STUDENT" ADD CONSTRAINT "STUDENT_ADRESA_FK" FOREIGN KEY ("ADRESA_ADRESA_KEY")
	  REFERENCES "ADRESA" ("ADRESA_KEY") ENABLE;
  ALTER TABLE "STUDENT" ADD CONSTRAINT "STUDENT_KOLEJ_FK" FOREIGN KEY ("KOLEJ_NAZEV_KOLEJE")
	  REFERENCES "KOLEJ" ("NAZEV_KOLEJE") ENABLE;
  ALTER TABLE "STUDENT" ADD CONSTRAINT "STUDENT_ROCNIK_FK" FOREIGN KEY ("ROCNIK_ID_ROCNIK")
	  REFERENCES "ROCNIK" ("ID_ROCNIK") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table STUDUJE
--------------------------------------------------------

  ALTER TABLE "STUDUJE" ADD CONSTRAINT "STUDUJE_POVINNE_VOLITELNY_FK" FOREIGN KEY ("POVINNE_VOLITELNY_NAZEV")
	  REFERENCES "POVINNE_VOLITELNY" ("NAZEV") ENABLE;
  ALTER TABLE "STUDUJE" ADD CONSTRAINT "STUDUJE_STUDENT_FK" FOREIGN KEY ("STUDENT_ID_STUDENT")
	  REFERENCES "STUDENT" ("ID_STUDENT") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table UCITEL
--------------------------------------------------------

  ALTER TABLE "UCITEL" ADD CONSTRAINT "UCITEL_PREDMET_FK" FOREIGN KEY ("PREDMET_NAZEV")
	  REFERENCES "PREDMET" ("NAZEV") ENABLE;
  ALTER TABLE "UCITEL" ADD CONSTRAINT "UCITEL_ZAMESTNANEC_FK" FOREIGN KEY ("ZAMESTNANEC_ID_ZAMESTNANEC")
	  REFERENCES "ZAMESTNANEC" ("ID_ZAMESTNANEC") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ZAMESTNANEC
--------------------------------------------------------

  ALTER TABLE "ZAMESTNANEC" ADD CONSTRAINT "ZAMESTNANEC_ADRESA_FK" FOREIGN KEY ("ADRESA_ADRESA_KEY")
	  REFERENCES "ADRESA" ("ADRESA_KEY") ENABLE;
