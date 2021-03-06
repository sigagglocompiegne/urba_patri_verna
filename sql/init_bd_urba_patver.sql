/*
#################################################################### SUIVI CODE SQL ####################################################################
2018-11-29 : FV / initialisation du code
*/

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        DROP                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- fkey
ALTER TABLE IF EXISTS m_urbanisme_reg.geo_patri_verna DROP CONSTRAINT IF EXISTS lt_patri_cat_patver_fkey;
ALTER TABLE IF EXISTS m_urbanisme_reg.geo_patri_verna DROP CONSTRAINT IF EXISTS lt_pei_src_geom_fkey;
-- classe
DROP TABLE IF EXISTS m_urbanisme_reg.geo_patri_verna;
-- domaine de valeur
DROP TABLE IF EXISTS m_urbanisme_reg.lt_patri_cat_patver;
-- sequence
DROP SEQUENCE IF EXISTS m_urbanisme_reg.geo_patri_verna_id_seq;



/*

-- #################################################################### SCHEMA  ####################################################################

-- Schema: m_urbanisme_reg

-- DROP SCHEMA m_urbanisme_reg;

CREATE SCHEMA m_urbanisme_reg
  AUTHORIZATION sig_create;

GRANT USAGE ON SCHEMA m_urbanisme_reg TO edit_sig;
GRANT ALL ON SCHEMA m_urbanisme_reg TO sig_create;
GRANT ALL ON SCHEMA m_urbanisme_reg TO create_sig;
GRANT USAGE ON SCHEMA m_urbanisme_reg TO read_sig;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_urbanisme_reg
GRANT ALL ON TABLES TO create_sig;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_urbanisme_reg
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO edit_sig;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_urbanisme_reg
GRANT SELECT ON TABLES TO read_sig;

COMMENT ON SCHEMA m_urbanisme_reg
  IS 'Données géographiques métiers sur l'urbanisme réglementaire';


*/


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- ################################################################# Domaine valeur - cat_patver  ###############################################

-- Table: m_urbanisme_reg.lt_patri_cat_patver

-- DROP TABLE m_urbanisme_reg.lt_patri_cat_patver;

CREATE TABLE m_urbanisme_reg.lt_patri_cat_patver
(
  code character varying(2) NOT NULL,
  valeur character varying(80) NOT NULL,
  CONSTRAINT lt_patri_cat_patver_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_urbanisme_reg.lt_patri_cat_patver
  OWNER TO sig_create;
GRANT SELECT ON TABLE m_urbanisme_reg.lt_patri_cat_patver TO read_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_urbanisme_reg.lt_patri_cat_patver TO edit_sig;
GRANT ALL ON TABLE m_urbanisme_reg.lt_patri_cat_patver TO create_sig;

COMMENT ON TABLE m_urbanisme_reg.lt_patri_cat_patver
  IS 'Code permettant de décrire la catégorie du patrimoine vernaculaire';
COMMENT ON COLUMN m_urbanisme_reg.lt_patri_cat_patver.code IS 'Code de la liste énumérée relative à la catégorie de patrimoine vernaculaire';
COMMENT ON COLUMN m_urbanisme_reg.lt_patri_cat_patver.valeur IS 'Valeur de la liste énumérée relative à la catégorie de patrimoine vernaculaire';

INSERT INTO m_urbanisme_reg.lt_patri_cat_patver(
            code, valeur)
    VALUES
    ('00','Non renseigné'),
    ('01','Borne'),
    ('02','Chasse-roue'),
    ('03','Décoration de façade'),
    ('04','Mur'),
    ('05','Plaque'),    
    ('99','Autre');

-- ################################################################# Domaine valeur - src_geom  ###############################################

-- Type d'énumération urbanisé et présent dans le schéma r_objet
-- Voir table r_objet.lt_src_geom

    
    
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      CLASSES                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### Point d'eau incendie ####################################################  
  
-- Table: m_urbanisme_reg.geo_patri_verna

-- DROP TABLE m_urbanisme_reg.geo_patri_verna;

CREATE TABLE m_urbanisme_reg.geo_patri_verna
(
  id_patver bigint NOT NULL,
  ref_doc character varying(5) NOT NULL, 
  cat_patver character varying(2) NOT NULL DEFAULT '00' ::bpchar,
  situation character varying(254),
  descriptif character varying(254),
  parcelle character varying(80),
  plu character varying(80),
  zppaup character varying(80),
  urlfic character varying(254),
  urlphoto1 character varying(254),
  urlphoto2 character varying(254),
  insee character varying(5) NOT NULL,
  commune character varying(150) NOT NULL,
  src_geom character varying(2) NOT NULL DEFAULT '00' ::bpchar,
  src_date character varying(4) NOT NULL DEFAULT '0000' ::bpchar,
  prec character varying(5) NOT NULL,
  ope_sai character varying(254),
  date_sai timestamp without time zone NOT NULL DEFAULT now(),  
  date_maj timestamp without time zone,
  geom geometry(MultiLineString,2154),
  geom1 geometry(Point,2154),

  CONSTRAINT geo_patri_verna_pkey PRIMARY KEY (id_patver)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_urbanisme_reg.geo_patri_verna
  OWNER TO sig_create;
GRANT SELECT ON TABLE m_urbanisme_reg.geo_patri_verna TO read_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_urbanisme_reg.geo_patri_verna TO edit_sig;
GRANT ALL ON TABLE m_urbanisme_reg.geo_patri_verna TO create_sig;

COMMENT ON TABLE m_urbanisme_reg.geo_patri_verna
  IS 'Patrimoine vernaculaire';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.id_patver IS 'Identifiant unique du patrimoine vernaculaire';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.ref_doc IS 'Référence du document du patrimoine vernaculaire';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.cat_patver IS 'Catégorie de patrimoine vernaculaire';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.situation IS 'Adresse ou information permettant de situer le patrimoine vernaculaire';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.descriptif IS 'Descriptif';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.parcelle IS 'Référence(s) de parcelle(s)';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.plu IS 'Zonage au PLU';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.zppaup IS 'Classement à la ZPPAUP';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.urlfic IS 'Lien vers le document d''inventaire du patrimoine vernaculaire';        
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.urlphoto1 IS 'Lien photo 1 du patrimoine vernaculaire';                                                                                                 
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.urlphoto2 IS 'Lien photo 2 du patrimoine vernaculaire';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.insee IS 'Code INSEE';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.commune IS 'Commune';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.src_geom IS 'Référentiel de saisie';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.src_date IS 'Année du millésime du référentiel de saisie';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.prec IS 'Précision cartographique exprimée en cm';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.ope_sai IS 'Opérateur de la dernière saisie en base de l''objet';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.geom IS 'Géométrie linéaire de l''objet';
COMMENT ON COLUMN m_urbanisme_reg.geo_patri_verna.geom1 IS 'Géométrie ponctuelle de l''objet';

-- Index: m_urbanisme_reg.geo_patri_verna_geom

-- DROP INDEX m_urbanisme_reg.geo_patri_verna_geom;

CREATE INDEX sidx_geo_patri_verna_geom
  ON m_urbanisme_reg.geo_patri_verna
  USING gist
  (geom);

-- Index: m_urbanisme_reg.geo_patri_verna_geom1

-- DROP INDEX m_urbanisme_reg.geo_patri_verna_geom1;

CREATE INDEX sidx_geo_patri_verna_geom1
  ON m_urbanisme_reg.geo_patri_verna
  USING gist
  (geom1);

-- Sequence: m_urbanisme_reg.geo_patri_verna_id_seq

-- DROP SEQUENCE m_urbanisme_reg.geo_patri_verna_id_seq;

CREATE SEQUENCE m_urbanisme_reg.geo_patri_verna_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE m_urbanisme_reg.geo_patri_verna_id_seq
  OWNER TO sig_create;
GRANT ALL ON SEQUENCE m_urbanisme_reg.geo_patri_verna_id_seq TO sig_create;
GRANT SELECT, USAGE ON SEQUENCE m_urbanisme_reg.geo_patri_verna_id_seq TO public;

ALTER TABLE m_urbanisme_reg.geo_patri_verna ALTER COLUMN id_patver SET DEFAULT nextval('m_urbanisme_reg.geo_patri_verna_id_seq'::regclass);


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        FKEY                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Foreign Key: m_urbanisme_reg.lt_patri_cat_patver_fkey

-- ALTER TABLE m_urbanisme_reg.geo_patri_verna DROP CONSTRAINT lt_patri_cat_patver_fkey;

ALTER TABLE m_urbanisme_reg.geo_patri_verna
  ADD CONSTRAINT lt_patri_cat_patver_fkey FOREIGN KEY (cat_patver)
      REFERENCES m_urbanisme_reg.lt_patri_cat_patver (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Foreign Key: m_urbanisme_reg.lt_pei_src_geom_fkey

-- ALTER TABLE m_urbanisme_reg.geo_patri_verna DROP CONSTRAINT lt_pei_src_geom_fkey;

ALTER TABLE m_urbanisme_reg.geo_patri_verna
  ADD CONSTRAINT lt_pei_src_geom_fkey FOREIGN KEY (src_geom)
      REFERENCES r_objet.lt_src_geom (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      
      

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        VUES                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- View: x_opendata.xopendata_geo_v_patri_verna

-- DROP VIEW x_opendata.xopendata_geo_v_patri_verna;

CREATE OR REPLACE VIEW x_opendata.xopendata_geo_v_patri_verna AS 
 SELECT g.id_patver,
    g.ref_doc,
    c.valeur as cat_patver,
    g.situation,
    g.descriptif,
    g.parcelle,
    g.plu,
    g.zppaup,
    g.urlfic,
    g.urlphoto1,
    g.urlphoto2,
    g.insee,
    g.commune,
    o.valeur as src_geom,
    g.src_date,
    g.prec,
    g.ope_sai,
    g.date_sai,
    g.date_maj,
    g.geom
   FROM m_urbanisme_reg.geo_patri_verna g
     LEFT JOIN m_urbanisme_reg.lt_patri_cat_patver c ON c.code::text = g.cat_patver::text
     LEFT JOIN r_objet.lt_src_geom o ON o.code::text = g.src_geom::text
  ORDER BY g.ref_doc;

ALTER TABLE x_opendata.xopendata_geo_v_patri_verna
  OWNER TO sig_create;
GRANT SELECT ON TABLE x_opendata.xopendata_geo_v_patri_verna TO read_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE x_opendata.xopendata_geo_v_patri_verna TO edit_sig;
GRANT ALL ON TABLE x_opendata.xopendata_geo_v_patri_verna TO create_sig;
COMMENT ON VIEW x_opendata.xopendata_geo_v_patri_verna
  IS 'Vue du patrimoine vernaculaire destinée aux échanges de données décodés en opendata';
          
