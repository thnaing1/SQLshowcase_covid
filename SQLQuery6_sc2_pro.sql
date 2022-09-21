CREATE TABLE sc2_units
	(unit_id INT,
	unit_name varchar(20),
	race varchar(10))


INSERT INTO sc2_units VALUES
(1, 'marine', 'terran'),
(2, 'zealot', 'protoss'),
(3, 'zergling', 'zerg'),
(4, 'marauder', 'terran'),
(5, 'stalker', 'protoss'),
(6, 'queen', 'zerg'),
(7, 'reaper', 'terran'),
(8, 'sentry', 'protoss'),
(9, 'baneling', 'zerg')

SELECT *
FROM sc2_units

CREATE TABLE pro_sc2
	(player_id INT,
	 gamer_tag varchar(20),
	 race varchar(10),
	 first_name varchar(20),
	 last_name varchar(20),
	 age INT,
	 country varchar(20),
	 nickname varchar(20),
	 aligulac_ranking INT,
	 total_winnings INT
	)

INSERT INTO pro_sc2 VALUES
(1, 'serral', 'zerg','Joona','Solata' , 23, 'finland', 'finnisher', 1, 970000),
(2, 'maru', 'terran' ,'Cho', 'Seong-ju', 24,'korea', 'marine_prince', 2, 960000),
(3, 'reynor','zerg','Riccardo', 'Romiti', 19, 'italy', 'italian_stallion', 3, 405000),
(4, 'dark', 'zerg','Park','Ryung Woo',27,'korea','final_boss',4, 856000),
(5, 'clem', 'terran','Clément', 'Desplanches', 19, 'france', 'little_corporal', 5, 160000),
(6, 'rogue','zerg','Lee','Byung Ryul', 27,'korea','cerebrate',6,961000),
(7, 'cure', 'terran','Kim','Doh Wook',27,'korea', 'none' ,7, 182000),
(8, 'byun','terran','Byun','Hyun Woo',28,'korea', 'micro_jackson', 8, 445000),
(9, 'maxpax', 'protoss', 'Max', 'Christensen', 17, 'denmark', 'none', 9, 24000),
(10, 'solar', 'zerg', 'Kang','Min Soo', 25, 'korea', 'shirt_eater', 10, 402000)

SELECT *
FROM pro_sc2