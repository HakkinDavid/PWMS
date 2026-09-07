import '../models/numismatic_models.dart';

/// Historical emission rules for Spain and the European Union (Antiguo Régimen, Pesetas, Euro & Eurozone).
const List<NumismaticEmissionRuleData> spainEmissionRules = [
  // 3.1 España - Antiguo Régimen y Monarquía Hispánica (1500–1868)
  NumismaticEmissionRuleData(
    country: 'España',
    minYear: 1500,
    maxYear: 1868,
    validCurrencies: ['REAL', 'ESC', 'MRV', 'RDV'],
    defaultCurrency: 'REAL',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/16',
        material: 'Cobre',
        minYear: 1500,
        maxYear: 1868,
        motifs: [
          NumismaticMotifRule('1/16 Real (Medio Maravedí / Maravedí Cobre)', 1500, 1868),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/8',
        material: 'Cobre',
        minYear: 1500,
        maxYear: 1868,
        motifs: [
          NumismaticMotifRule('1/8 Real (2 Maravedís / 4 Maravedís Cobre)', 1500, 1868),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Cobre'],
        minYear: 1500,
        maxYear: 1868,
        motifs: [
          NumismaticMotifRule('Cuartillo de Real Plata / 8 Maravedís Cobre', 1500, 1868),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        material: 'Plata',
        minYear: 1500,
        maxYear: 1868,
        motifs: [
          NumismaticMotifRule('Medio Real Plata', 1500, 1868),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1500,
        maxYear: 1868,
        motifs: [
          NumismaticMotifRule('1 Real de Plata', 1500, 1868),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1500,
        maxYear: 1868,
        motifs: [
          NumismaticMotifRule('2 Reales de Plata (Pistolete / Dos Reales)', 1500, 1868),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        material: 'Plata',
        minYear: 1500,
        maxYear: 1868,
        motifs: [
          NumismaticMotifRule('4 Reales de Plata (Medio Duro)', 1500, 1868),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        material: 'Plata',
        minYear: 1500,
        maxYear: 1868,
        motifs: [
          NumismaticMotifRule('8 Reales de Plata (Real de a Ocho / Columnario / Busto / Duro)', 1500, 1868),
        ],
      ),
    ],
  ),

  // 3.2 España - Peseta Clásica (1869–1939)
  NumismaticEmissionRuleData(
    country: 'España',
    minYear: 1869,
    maxYear: 1939,
    validCurrencies: ['ESP'],
    defaultCurrency: 'ESP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Bronce',
        minYear: 1870,
        maxYear: 1870,
        motifs: [
          NumismaticMotifRule('1 Céntimo de Peseta (León rampante / Hispania)', 1870),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Bronce',
        minYear: 1870,
        maxYear: 1870,
        motifs: [
          NumismaticMotifRule('2 Céntimos de Peseta (León rampante / Hispania)', 1870),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Bronce',
        minYear: 1870,
        maxYear: 1879,
        motifs: [
          NumismaticMotifRule('5 Céntimos de Peseta (Perra Chica)', 1870, 1879),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Bronce',
        minYear: 1870,
        maxYear: 1879,
        motifs: [
          NumismaticMotifRule('10 Céntimos de Peseta (Perra Gorda)', 1870, 1879),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        material: 'Cuproníquel',
        minYear: 1925,
        maxYear: 1937,
        motifs: [
          NumismaticMotifRule('25 Céntimos con agujero (Carabela / Gallega)', 1925, 1937),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Plata',
        minYear: 1869,
        maxYear: 1926,
        motifs: [
          NumismaticMotifRule('50 Céntimos de Plata .835', 1869, 1926),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Plata',
        minYear: 1869,
        maxYear: 1937,
        motifs: [
          NumismaticMotifRule('1 Peseta de Plata .835 (Hispania / Reyes)', 1869, 1937),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Plata',
        minYear: 1869,
        maxYear: 1905,
        motifs: [
          NumismaticMotifRule('2 Pesetas de Plata .835', 1869, 1905),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Plata',
        minYear: 1869,
        maxYear: 1899,
        motifs: [
          NumismaticMotifRule('5 Pesetas de Plata .900 (Duro de Plata)', 1869, 1899),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Oro',
        minYear: 1878,
        maxYear: 1879,
        motifs: [
          NumismaticMotifRule('10 Pesetas Oro .900 (Alfonso XII)', 1878, 1879),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Oro',
        minYear: 1889,
        maxYear: 1904,
        motifs: [
          NumismaticMotifRule('20 Pesetas Oro .900 (Alfonso XIII)', 1889, 1904),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '25',
        material: 'Oro',
        minYear: 1876,
        maxYear: 1881,
        motifs: [
          NumismaticMotifRule('25 Pesetas Oro .900 (Alfonso XII)', 1876, 1881),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Oro',
        minYear: 1870,
        maxYear: 1897,
        motifs: [
          NumismaticMotifRule('100 Pesetas Oro .900', 1870, 1897),
        ],
      ),
    ],
  ),

  // 3.3 España - Peseta del Estado Español y Transición (1940–1981)
  NumismaticEmissionRuleData(
    country: 'España',
    minYear: 1940,
    maxYear: 1981,
    validCurrencies: ['ESP'],
    defaultCurrency: 'ESP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Aluminio',
        minYear: 1940,
        maxYear: 1953,
        motifs: [
          NumismaticMotifRule('5 Céntimos Jinete Ibérico', 1940, 1953),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Aluminio',
        minYear: 1940,
        maxYear: 1959,
        motifs: [
          NumismaticMotifRule('10 Céntimos Jinete Ibérico', 1940, 1959),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Cuproníquel',
        minYear: 1949,
        maxYear: 1975,
        motifs: [
          NumismaticMotifRule('50 Céntimos Timón y Ancla con agujero', 1949, 1975),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bronce de aluminio',
        minYear: 1944,
        maxYear: 1981,
        motifs: [
          NumismaticMotifRule('1 Peseta (Rubia de Franco / Juan Carlos I)', 1944, 1981),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2.5',
        material: 'Bronce de aluminio',
        minYear: 1953,
        maxYear: 1953,
        motifs: [
          NumismaticMotifRule('2.50 Pesetas Franco', 1953),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Cuproníquel',
        minYear: 1949,
        maxYear: 1980,
        motifs: [
          NumismaticMotifRule('5 Pesetas (Duro de Franco / Juan Carlos I)', 1949, 1980),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '25',
        material: 'Cuproníquel',
        minYear: 1957,
        maxYear: 1980,
        motifs: [
          NumismaticMotifRule('25 Pesetas con agujero (Corona / Juan Carlos I)', 1957, 1980),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Cuproníquel',
        minYear: 1957,
        maxYear: 1980,
        motifs: [
          NumismaticMotifRule('50 Pesetas (Franco / Juan Carlos I)', 1957, 1980),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Plata',
        allowedMaterials: ['Plata', 'Cuproníquel'],
        minYear: 1966,
        maxYear: 1975,
        motifs: [
          NumismaticMotifRule(
          '100 Pesetas Franco Plata .800',
          1966,
          1966,
          ),
          NumismaticMotifRule(
          '100 Pesetas Juan Carlos I Cuproníquel',
          1975,
          1975,
          ),
        ],
      ),
    ],
  ),

  // 3.4 España - Peseta Moderna y Monedas Autonómicas (1982–2001)
  NumismaticEmissionRuleData(
    country: 'España',
    minYear: 1982,
    maxYear: 2001,
    validCurrencies: ['ESP'],
    defaultCurrency: 'ESP',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Aluminio',
        minYear: 1983,
        maxYear: 1998,
        motifs: [
          NumismaticMotifRule('10 Céntimos Aluminio', 1983, 1998),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Aluminio',
        minYear: 1980,
        maxYear: 1989,
        motifs: [
          NumismaticMotifRule('50 Céntimos España 82', 1980, 1989),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Aluminio',
        minYear: 1982,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('1 Peseta Aluminio (Grande 1982-1989 / Lenteja 1989-2001)', 1982, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Aluminio',
        minYear: 1982,
        maxYear: 1984,
        motifs: [
          NumismaticMotifRule('2 Pesetas Aluminio España 82', 1982, 1984),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        material: 'Bronce de aluminio',
        minYear: 1989,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('5 Pesetas Bronce de aluminio', 1989, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Cuproníquel',
        minYear: 1983,
        maxYear: 2000,
        motifs: [
          NumismaticMotifRule('10 Pesetas Cuproníquel', 1983, 2000),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '25',
        material: 'Bronce de aluminio',
        minYear: 1990,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule(
          'Corona Real y Letra M (1990-2000)',
          1990,
          2000,
          ),
          NumismaticMotifRule('Juegos Olímpicos de Barcelona 92 (1990-1992)', 1990, 1992),
          NumismaticMotifRule('Castilla y León', 1993, 1993),
          NumismaticMotifRule('País Vasco', 1994, 1994),
          NumismaticMotifRule('Canarias', 1995, 1995),
          NumismaticMotifRule('Principado de Asturias', 1996, 1996),
          NumismaticMotifRule('Castilla-La Mancha', 1997, 1997),
          NumismaticMotifRule('Melilla', 1997, 1997),
          NumismaticMotifRule('Ceuta', 1998, 1998),
          NumismaticMotifRule('Comunidad Foral de Navarra', 1999, 1999),
          NumismaticMotifRule('Palacio Real de Madrid', 2000, 2000),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        material: 'Cuproníquel',
        minYear: 1990,
        maxYear: 2000,
        motifs: [
          NumismaticMotifRule('50 Pesetas Flor de Lis / Pantalla', 1990, 2000),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        material: 'Bronce de aluminio',
        minYear: 1982,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('100 Pesetas (20 Duros)', 1982, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        material: 'Cuproníquel',
        minYear: 1986,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('200 Pesetas Cuproníquel', 1986, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        material: 'Bronce de aluminio',
        minYear: 1987,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('500 Pesetas Bronce de aluminio', 1987, 2001),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2000',
        material: 'Plata',
        minYear: 1994,
        maxYear: 2001,
        motifs: [
          NumismaticMotifRule('Asamblea del FMI y Banco Mundial - Madrid', 1994, 1994),
          NumismaticMotifRule('Presidencia Española del Consejo de la Unión Europea', 1995, 1995),
          NumismaticMotifRule('IV Centenario de Don Quijote y Sancho', 1996, 1996),
          NumismaticMotifRule('400 Aniversario de Juan de Herrera', 1997, 1997),
          NumismaticMotifRule('IV Centenario de la Muerte de Felipe II', 1998, 1998),
          NumismaticMotifRule('Año Santo Xacobeo', 1999, 1999),
          NumismaticMotifRule('V Centenario del Nacimiento de Carlos V', 2000, 2000),
          NumismaticMotifRule('Última Emisión de la Peseta - Hispania', 2001, 2001),
        ],
      ),
    ],
  ),

  // 3.5 España - Época del Euro (grabadas físicamente 1999–presente)
  NumismaticEmissionRuleData(
    country: 'España',
    minYear: 1999,
    maxYear: 2100,
    validCurrencies: ['EUR'],
    defaultCurrency: 'EUR',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Acero bañado en cobre',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Catedral de Santiago de Compostela', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Acero bañado en cobre',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Catedral de Santiago de Compostela', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero bañado en cobre',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Catedral de Santiago de Compostela', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Oro nórdico',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Miguel de Cervantes', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Oro nórdico',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Miguel de Cervantes', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Oro nórdico',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Miguel de Cervantes', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bimetálica',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('Rey Juan Carlos I / Rey Felipe VI', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule(
          'Efigie del Rey Juan Carlos I / Rey Felipe VI (Circulación Estándar)',
          1999,
          2100,
          ),
          NumismaticMotifRule('IV Centenario de Don Quijote de la Mancha', 2005, 2005),
          NumismaticMotifRule('50 Aniversario del Tratado de Roma', 2007, 2007),
          NumismaticMotifRule('10 Años de la Unión Económica y Monetaria', 2009, 2009),
          NumismaticMotifRule('Centro Histórico de Córdoba - Mezquita-Catedral (UNESCO 2010)', 2010, 2010),
          NumismaticMotifRule('La Alhambra, Generalife y Albaicín de Granada (UNESCO 2011)', 2011, 2011),
          NumismaticMotifRule('Catedral de Burgos (UNESCO 2012)', 2012, 2012),
          NumismaticMotifRule('10 Años de los Billetes y Monedas en Euros', 2012, 2012),
          NumismaticMotifRule('Real Monasterio de San Lorenzo de El Escorial (UNESCO 2013)', 2013, 2013),
          NumismaticMotifRule('Parque Güell - Obras de Antoni Gaudí (UNESCO 2014)', 2014, 2014),
          NumismaticMotifRule('Proclamación de Su Majestad el Rey Felipe VI', 2014, 2014),
          NumismaticMotifRule('Cueva de Altamira y Arte Rupestre del Norte de España (UNESCO 2015)', 2015, 2015),
          NumismaticMotifRule('30 Años de la Bandera de la Unión Europea', 2015, 2015),
          NumismaticMotifRule('Acueducto de Segovia (UNESCO 2016)', 2016, 2016),
          NumismaticMotifRule('Monumentos de Oviedo y del Reino de Asturias (UNESCO 2017)', 2017, 2017),
          NumismaticMotifRule('50 Aniversario del Nacimiento del Rey Felipe VI', 2018, 2018),
          NumismaticMotifRule('Ciudad Vieja de Santiago de Compostela (UNESCO 2018)', 2018, 2018),
          NumismaticMotifRule('Murallas y Ciudad Vieja de Ávila (UNESCO 2019)', 2019, 2019),
          NumismaticMotifRule('Arquitectura Mudéjar de Aragón (UNESCO 2020)', 2020, 2020),
          NumismaticMotifRule('Ciudad Histórica de Toledo (UNESCO 2021)', 2021, 2021),
          NumismaticMotifRule('Parque Nacional de Garajonay (UNESCO 2022)', 2022, 2022),
          NumismaticMotifRule('V Centenario de la Vuelta al Mundo de Juan Sebastián Elcano', 2022, 2022),
          NumismaticMotifRule('35 Años del Programa Erasmus', 2022, 2022),
          NumismaticMotifRule('Ciudad Vieja de Cáceres (UNESCO 2023)', 2023, 2023),
          NumismaticMotifRule('Presidencia Española del Consejo de la Unión Europea', 2023, 2023),
          NumismaticMotifRule('Catedral, Alcázar y Archivo de Indias de Sevilla (UNESCO 2024)', 2024, 2024),
          NumismaticMotifRule('Bicentenario de la Policía Nacional', 2024, 2024),
          NumismaticMotifRule('Paisaje de la Luz de Madrid (UNESCO 2025)', 2025, 2025),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        material: 'Plata',
        minYear: 2002,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('10 Euros Plata Conmemorativa', 2002, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '12',
        material: 'Plata',
        minYear: 2002,
        maxYear: 2010,
        motifs: [
          NumismaticMotifRule('12 Euros Plata Conmemorativa', 2002, 2010),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        material: 'Plata',
        minYear: 2010,
        maxYear: 2011,
        motifs: [
          NumismaticMotifRule('20 Euros Plata Conmemorativa', 2010, 2011),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '30',
        material: 'Plata',
        minYear: 2012,
        maxYear: 2020,
        motifs: [
          NumismaticMotifRule('30 Euros Plata Conmemorativa', 2012, 2020),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '40',
        material: 'Plata',
        minYear: 2021,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('40 Euros Plata Conmemorativa', 2021, 2100),
        ],
      ),
    ],
  ),

  // 3.6 Unión Europea (Zona Euro, grabadas físicamente 1999–presente)
  NumismaticEmissionRuleData(
    country: 'Unión Europea',
    minYear: 1999,
    maxYear: 2100,
    validCurrencies: ['EUR'],
    defaultCurrency: 'EUR',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        material: 'Acero bañado en cobre',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('1 Céntimo de Euro Común (Globo Terráqueo)', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        material: 'Acero bañado en cobre',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('2 Céntimos de Euro Común (Globo Terráqueo)', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        material: 'Acero bañado en cobre',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('5 Céntimos de Euro Común (Globo Terráqueo)', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        material: 'Oro nórdico',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('10 Céntimos de Euro Común (Mapa Europeo)', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        material: 'Oro nórdico',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('20 Céntimos de Euro Común (Mapa Europeo)', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        material: 'Oro nórdico',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('50 Céntimos de Euro Común (Mapa Europeo)', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        material: 'Bimetálica',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule('1 Euro Común (Mapa Europeo)', 1999, 2100),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        material: 'Bimetálica',
        minYear: 1999,
        maxYear: 2100,
        motifs: [
          NumismaticMotifRule(
          'Mapa de Europa / Unión Europea (Cara Común Estándar)',
          1999,
          2100,
          ),
          NumismaticMotifRule('50 Aniversario del Tratado de Roma', 2007, 2007),
          NumismaticMotifRule('10 Años de la Unión Económica y Monetaria', 2009, 2009),
          NumismaticMotifRule('10 Años de los Billetes y Monedas en Euros', 2012, 2012),
          NumismaticMotifRule('30 Años de la Bandera de la Unión Europea', 2015, 2015),
          NumismaticMotifRule('35 Años del Programa Erasmus', 2022, 2022),
        ],
      ),
    ],
  ),
];
