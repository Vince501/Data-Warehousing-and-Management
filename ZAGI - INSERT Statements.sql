INSERT INTO zagi.VENDOR VALUES ('PG','Pacifica Gear');
INSERT INTO zagi.VENDOR VALUES ('MK','Mountain King');
INSERT INTO zagi.VENDOR VALUES ('OA','Outdoor Adventures');
INSERT INTO zagi.VENDOR VALUES ('WL','Wilderness Limited');

INSERT INTO zagi.CATEGORY VALUES ('CP','Camping');
INSERT INTO zagi.CATEGORY VALUES ('FW','Footwear');
INSERT INTO zagi.CATEGORY VALUES ('CL','Climbing');
INSERT INTO zagi.CATEGORY VALUES ('EL','Electronics');
INSERT INTO zagi.CATEGORY VALUES ('CY','Cycling');

INSERT INTO zagi.PRODUCT VALUES ('1X1','Zzz Bag',100,'PG','CP');
INSERT INTO zagi.PRODUCT VALUES ('2X2','Easy Boot',70,'MK','FW');
INSERT INTO zagi.PRODUCT VALUES ('3X3','Cosy Sock',15,'MK','FW');
INSERT INTO zagi.PRODUCT VALUES ('4X4','Dura Boot',90,'PG','FW');
INSERT INTO zagi.PRODUCT VALUES ('5X5','Tiny Tent',150,'MK','CP');
INSERT INTO zagi.PRODUCT VALUES ('6X6','Biggy Tent',250,'MK','CP');
INSERT INTO zagi.PRODUCT VALUES ('7X7','Hi-Tec GPS',300,'OA','EL');
INSERT INTO zagi.PRODUCT VALUES ('8X8','Power Pedals',20,'MK','CY');
INSERT INTO zagi.PRODUCT VALUES ('9X9','Trusty Rope',30,'WL','CL');
INSERT INTO zagi.PRODUCT VALUES ('1X2','Comfy Harness',150,'MK','CL');
INSERT INTO zagi.PRODUCT VALUES ('1X3','Sunny Charger',125,'OA','EL');
INSERT INTO zagi.PRODUCT VALUES ('1X4','Safe-T Helmet',40,'PG','CY');
INSERT INTO zagi.PRODUCT VALUES ('2X1','Mmm Stove',80,'WL','CP');
INSERT INTO zagi.PRODUCT VALUES ('2X3','Reflect-o Jacket',35,'PG','CY');
INSERT INTO zagi.PRODUCT VALUES ('2X4','Strongster Carribeaner',20,'MK','CL');
INSERT INTO zagi.PRODUCT VALUES ('3X1','Sleepy Pad',25,'WL','CP');
INSERT INTO zagi.PRODUCT VALUES ('3X2','Bucky Knife',60,'WL','CP');
INSERT INTO zagi.PRODUCT VALUES ('3X4','Treado Tire',30,'OA','CY');
INSERT INTO zagi.PRODUCT VALUES ('4X1','Slicky Tire',25,'OA','CY');
INSERT INTO zagi.PRODUCT VALUES ('4X2','Electra Compass',45,'MK','EL');
INSERT INTO zagi.PRODUCT VALUES ('4X3','Mega Camera',275,'WL','EL');
INSERT INTO zagi.PRODUCT VALUES ('5X1','Simple Sandal',50,'PG','FW');
INSERT INTO zagi.PRODUCT VALUES ('5X2','Action Sandal',70,'PG','FW');
INSERT INTO zagi.PRODUCT VALUES ('5X3','Luxo Tent',500,'OA','CP');

INSERT INTO zagi.REGION VALUES ('C','Chicagoland');
INSERT INTO zagi.REGION VALUES ('T','Tristate');
INSERT INTO zagi.REGION VALUES ('I','Indiana');
INSERT INTO zagi.REGION VALUES ('N','North');

INSERT INTO zagi.STORE VALUES ('S1','60600','C ');
INSERT INTO zagi.STORE VALUES ('S2','60605','C');
INSERT INTO zagi.STORE VALUES ('S3','35400','T');
INSERT INTO zagi.STORE VALUES ('S4','60640','C');
INSERT INTO zagi.STORE VALUES ('S5','46307','T');
INSERT INTO zagi.STORE VALUES ('S6','47374','I');
INSERT INTO zagi.STORE VALUES ('S7','47401','I');
INSERT INTO zagi.STORE VALUES ('S8','55401','N');
INSERT INTO zagi.STORE VALUES ('S9','54937','N');
INSERT INTO zagi.STORE VALUES ('S10','60602','C');
INSERT INTO zagi.STORE VALUES ('S11','46201','I');
INSERT INTO zagi.STORE VALUES ('S12','55701','N');
INSERT INTO zagi.STORE VALUES ('S13','60085','T');
INSERT INTO zagi.STORE VALUES ('S14','53140','T');

INSERT INTO zagi.CUSTOMER VALUES ('1-2-333','Tina','60137');
INSERT INTO zagi.CUSTOMER VALUES ('2-3-444','Tony','60611');
INSERT INTO zagi.CUSTOMER VALUES ('3-4-555','Pam','35401');
INSERT INTO zagi.CUSTOMER VALUES ('4-5-666','Elly','47374');
INSERT INTO zagi.CUSTOMER VALUES ('5-6-777','Nora','60640');
INSERT INTO zagi.CUSTOMER VALUES ('6-7-888','Miles','60602');
INSERT INTO zagi.CUSTOMER VALUES ('7-8-999','Neil','55403');
INSERT INTO zagi.CUSTOMER VALUES ('8-9-000','Maggie','47401');
INSERT INTO zagi.CUSTOMER VALUES ('9-0-111','Ryan','46202');
INSERT INTO zagi.CUSTOMER VALUES ('0-1-222','Dan','55499');

INSERT INTO zagi.SALESTRANSACTION VALUES ('T111','1-2-333','S1','2023-01-01');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T222','2-3-444','S2','2023-01-01');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T333','1-2-333','S3','2023-01-02');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T444','3-4-555','S3','2023-01-02');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T555','2-3-444','S3','2023-01-02');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T666','5-6-777','S10','2023-01-03');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T777','6-7-888','S13','2023-01-03');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T888','8-9-000','S4','2023-01-04');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T999','4-5-666','S6','2023-01-04');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T101','7-8-999','S12','2023-01-04');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T202','0-1-222','S8','2023-01-04');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T303','4-5-666','S6','2023-01-05');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T404','8-9-000','S6','2023-01-05');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T505','6-7-888','S14','2023-01-05');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T606','0-1-222','S11','2023-01-06');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T707','5-6-777','S4','2023-01-06');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T808','7-8-999','S9','2023-01-06');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T909','5-6-777','S4','2023-01-06');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T011','8-9-000','S7','2023-01-07');
INSERT INTO zagi.SALESTRANSACTION VALUES ('T022','9-0-111','S5','2023-01-07');

INSERT INTO zagi.INCLUDES VALUES ('1X1','T111',1);
INSERT INTO zagi.INCLUDES VALUES ('2X2','T222',1);
INSERT INTO zagi.INCLUDES VALUES ('3X3','T333',5);
INSERT INTO zagi.INCLUDES VALUES ('1X1','T333',1);
INSERT INTO zagi.INCLUDES VALUES ('4X4','T444',1);
INSERT INTO zagi.INCLUDES VALUES ('2X2','T444',2);
INSERT INTO zagi.INCLUDES VALUES ('4X4','T555',4);
INSERT INTO zagi.INCLUDES VALUES ('5X5','T555',2);
INSERT INTO zagi.INCLUDES VALUES ('6X6','T555',1);
INSERT INTO zagi.INCLUDES VALUES ('7X7','T666',1);
INSERT INTO zagi.INCLUDES VALUES ('9X9','T666',1);
INSERT INTO zagi.INCLUDES VALUES ('1X3','T666',2);
INSERT INTO zagi.INCLUDES VALUES ('8X8','T777',1);
INSERT INTO zagi.INCLUDES VALUES ('1X4','T888',4);
INSERT INTO zagi.INCLUDES VALUES ('2X3','T888',3);
INSERT INTO zagi.INCLUDES VALUES ('9X9','T999',1);
INSERT INTO zagi.INCLUDES VALUES ('1X2','T999',5);
INSERT INTO zagi.INCLUDES VALUES ('8X8','T999',3);
INSERT INTO zagi.INCLUDES VALUES ('1X3','T999',1);
INSERT INTO zagi.INCLUDES VALUES ('1X2','T101',3);
INSERT INTO zagi.INCLUDES VALUES ('1X4','T101',1);
INSERT INTO zagi.INCLUDES VALUES ('2X4','T202',4);
INSERT INTO zagi.INCLUDES VALUES ('9X9','T303',3);
INSERT INTO zagi.INCLUDES VALUES ('1X4','T303',2);
INSERT INTO zagi.INCLUDES VALUES ('2X1','T303',2);
INSERT INTO zagi.INCLUDES VALUES ('3X1','T303',2);
INSERT INTO zagi.INCLUDES VALUES ('2X4','T404',1);
INSERT INTO zagi.INCLUDES VALUES ('2X3','T404',2);
INSERT INTO zagi.INCLUDES VALUES ('2X2','T505',3);
INSERT INTO zagi.INCLUDES VALUES ('3X2','T505',1);
INSERT INTO zagi.INCLUDES VALUES ('2X1','T505',4);
INSERT INTO zagi.INCLUDES VALUES ('2X4','T606',7);
INSERT INTO zagi.INCLUDES VALUES ('3X1','T606',4);
INSERT INTO zagi.INCLUDES VALUES ('2X2','T606',3);
INSERT INTO zagi.INCLUDES VALUES ('3X4','T606',2);
INSERT INTO zagi.INCLUDES VALUES ('4X4','T606',2);
INSERT INTO zagi.INCLUDES VALUES ('3X2','T707',1);
INSERT INTO zagi.INCLUDES VALUES ('3X4','T707',4);
INSERT INTO zagi.INCLUDES VALUES ('4X1','T707',2);
INSERT INTO zagi.INCLUDES VALUES ('5X3','T808',1);
INSERT INTO zagi.INCLUDES VALUES ('4X2','T808',1);
INSERT INTO zagi.INCLUDES VALUES ('2X2','T808',1);
INSERT INTO zagi.INCLUDES VALUES ('4X3','T808',1);
INSERT INTO zagi.INCLUDES VALUES ('3X3','T808',4);
INSERT INTO zagi.INCLUDES VALUES ('4X2','T909',3);
INSERT INTO zagi.INCLUDES VALUES ('6X6','T909',1);
INSERT INTO zagi.INCLUDES VALUES ('3X3','T011',3);
INSERT INTO zagi.INCLUDES VALUES ('4X3','T022',3);
INSERT INTO zagi.INCLUDES VALUES ('2X2','T022',3);
INSERT INTO zagi.INCLUDES VALUES ('5X1','T022',2);
