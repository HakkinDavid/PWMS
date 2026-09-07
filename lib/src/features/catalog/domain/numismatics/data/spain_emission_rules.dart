import '../models/numismatic_models.dart';

/// Historical emission rules for Spain and the European Union (Antiguo Régimen, Pesetas, Euro & Eurozone).
const List<NumismaticEmissionRuleData> spainEmissionRules = [
  // 3.1 España - Antiguo Régimen y Monarquía Hispánica (1500–1868)
  NumismaticEmissionRuleData(
    country: 'España',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '1/16',
        currency: 'REAL',
        motifs: [
          NumismaticMotifRule(
            'Medio Maravedí / Maravedí Cobre',
            minYear: 1500,
            maxYear: 1868,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/8',
        currency: 'REAL',
        motifs: [
          NumismaticMotifRule(
            '2 Maravedís / 4 Maravedís Cobre',
            minYear: 1500,
            maxYear: 1868,
            material: 'Cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/4',
        currency: 'REAL',
        motifs: [
          NumismaticMotifRule(
            'Castillo y León / Maravedís',
            minYear: 1500,
            maxYear: 1868,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1/2',
        currency: 'REAL',
        motifs: [
          NumismaticMotifRule(
            'Monograma Real Coronado / Columnas y Castillo (Medio Real)',
            minYear: 1500,
            maxYear: 1868,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'REAL',
        motifs: [
          NumismaticMotifRule(
            'Escudo Real Coronado / Columnario y Busto (Un Real)',
            minYear: 1500,
            maxYear: 1868,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        currency: 'REAL',
        motifs: [
          NumismaticMotifRule(
            'Pistolete / Dos Reales',
            minYear: 1500,
            maxYear: 1868,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '4',
        currency: 'REAL',
        motifs: [
          NumismaticMotifRule(
            'Medio Duro',
            minYear: 1500,
            maxYear: 1868,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '8',
        currency: 'REAL',
        motifs: [
          NumismaticMotifRule(
            'Real de a Ocho / Columnario / Busto / Duro',
            minYear: 1500,
            maxYear: 1868,
            material: 'Plata',
          ),
        ],
      ),
    ],
  ),

  // 3.2 España - Peseta Clásica (1869–1939)
  NumismaticEmissionRuleData(
    country: 'España',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Peseta (León rampante / Hispania)',
            minYear: 1870,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Peseta (León rampante / Hispania)',
            minYear: 1870,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Peseta (Perra Chica)',
            minYear: 1870,
            maxYear: 1879,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Peseta (Perra Gorda)',
            minYear: 1870,
            maxYear: 1879,
            material: 'Bronce',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.25',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'con agujero (Carabela / Gallega)',
            minYear: 1925,
            maxYear: 1937,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Hispania Recostada / Reyes Alfonso XII y XIII (Escudo de España)',
            minYear: 1869,
            maxYear: 1926,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Plata .835 (Hispania / Reyes)',
            minYear: 1869,
            maxYear: 1937,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Hispania / Bustos Reales (Alfonso XII y XIII)',
            minYear: 1869,
            maxYear: 1905,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Duro de Plata (.900)',
            minYear: 1869,
            maxYear: 1899,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Alfonso XII (Oro .900)',
            minYear: 1878,
            maxYear: 1879,
            material: 'Oro',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Alfonso XIII (Oro .900)',
            minYear: 1889,
            maxYear: 1904,
            material: 'Oro',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '25',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Alfonso XII (Oro .900)',
            minYear: 1876,
            maxYear: 1881,
            material: 'Oro',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Hispania de Pie / Busto de Alfonso XIII Niño (Escudo Real)',
            minYear: 1870,
            maxYear: 1897,
            material: 'Oro',
          ),
        ],
      ),
    ],
  ),

  // 3.3 España - Peseta del Estado Español y Transición (1940–1981)
  NumismaticEmissionRuleData(
    country: 'España',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.05',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Jinete Ibérico',
            minYear: 1940,
            maxYear: 1953,
            material: 'Aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Jinete Ibérico',
            minYear: 1940,
            maxYear: 1959,
            material: 'Aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Timón y Ancla con agujero',
            minYear: 1949,
            maxYear: 1975,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            '(Rubia de Franco / Juan Carlos I)',
            minYear: 1944,
            maxYear: 1981,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2.5',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Franco',
            minYear: 1953,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            '(Duro de Franco / Juan Carlos I)',
            minYear: 1949,
            maxYear: 1980,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '25',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'con agujero (Corona / Juan Carlos I)',
            minYear: 1957,
            maxYear: 1980,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            '(Franco / Juan Carlos I)',
            minYear: 1957,
            maxYear: 1980,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Franco Plata .800',
            minYear: 1966,
            material: 'Plata',
          ),
          NumismaticMotifRule(
            'Juan Carlos I Cuproníquel',
            minYear: 1975,
            material: 'Plata',
          ),
        ],
      ),
    ],
  ),

  // 3.4 España - Peseta Moderna y Monedas Autonómicas (1982–2001)
  NumismaticEmissionRuleData(
    country: 'España',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Busto del Rey Juan Carlos I / Escudo de España',
            minYear: 1983,
            maxYear: 1998,
            material: 'Aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'España 82',
            minYear: 1980,
            maxYear: 1989,
            material: 'Aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Grande / Lenteja',
            minYear: 1982,
            maxYear: 2001,
            material: 'Aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'España 82',
            minYear: 1982,
            maxYear: 1984,
            material: 'Aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '5',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Busto del Rey Juan Carlos I / Numeral 5 PTAS (Duro Pequeño)',
            minYear: 1989,
            maxYear: 2001,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Busto del Rey Juan Carlos I / Homenajes Culturales',
            minYear: 1983,
            maxYear: 2000,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '25',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Corona Real y Letra M (1990-2000)',
            minYear: 1990,
            maxYear: 2000,
            material: 'Bronce de aluminio',
          ),
          NumismaticMotifRule(
            'Juegos Olímpicos de Barcelona 92 (1990-1992)',
            minYear: 1990,
            maxYear: 1992,
            material: 'Bronce de aluminio',
          ),
          NumismaticMotifRule(
            'Castilla y León',
            minYear: 1993,
            material: 'Bronce de aluminio',
          ),
          NumismaticMotifRule(
            'País Vasco',
            minYear: 1994,
            material: 'Bronce de aluminio',
          ),
          NumismaticMotifRule(
            'Canarias',
            minYear: 1995,
            material: 'Bronce de aluminio',
          ),
          NumismaticMotifRule(
            'Principado de Asturias',
            minYear: 1996,
            material: 'Bronce de aluminio',
          ),
          NumismaticMotifRule(
            'Castilla-La Mancha',
            minYear: 1997,
            material: 'Bronce de aluminio',
          ),
          NumismaticMotifRule(
            'Melilla',
            minYear: 1997,
            material: 'Bronce de aluminio',
          ),
          NumismaticMotifRule(
            'Ceuta',
            minYear: 1998,
            material: 'Bronce de aluminio',
          ),
          NumismaticMotifRule(
            'Comunidad Foral de Navarra',
            minYear: 1999,
            material: 'Bronce de aluminio',
          ),
          NumismaticMotifRule(
            'Palacio Real de Madrid',
            minYear: 2000,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '50',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Flor de Lis / Pantalla',
            minYear: 1990,
            maxYear: 2000,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '100',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            '(20 Duros)',
            minYear: 1982,
            maxYear: 2001,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '200',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Rey Juan Carlos I y Príncipe Felipe / Patrimonio Cultural',
            minYear: 1986,
            maxYear: 2001,
            material: 'Cuproníquel',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '500',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Reyes Juan Carlos I y Sofía / Escudo Nacional',
            minYear: 1987,
            maxYear: 2001,
            material: 'Bronce de aluminio',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2000',
        currency: 'ESP',
        motifs: [
          NumismaticMotifRule(
            'Asamblea del FMI y Banco Mundial - Madrid',
            minYear: 1994,
            material: 'Plata',
          ),
          NumismaticMotifRule(
            'Presidencia Española del Consejo de la Unión Europea',
            minYear: 1995,
            material: 'Plata',
          ),
          NumismaticMotifRule(
            'IV Centenario de Don Quijote y Sancho',
            minYear: 1996,
            material: 'Plata',
          ),
          NumismaticMotifRule(
            '400 Aniversario de Juan de Herrera',
            minYear: 1997,
            material: 'Plata',
          ),
          NumismaticMotifRule(
            'IV Centenario de la Muerte de Felipe II',
            minYear: 1998,
            material: 'Plata',
          ),
          NumismaticMotifRule(
            'Año Santo Xacobeo',
            minYear: 1999,
            material: 'Plata',
          ),
          NumismaticMotifRule(
            'V Centenario del Nacimiento de Carlos V',
            minYear: 2000,
            material: 'Plata',
          ),
          NumismaticMotifRule(
            'Última Emisión de la Peseta - Hispania',
            minYear: 2001,
            material: 'Plata',
          ),
        ],
      ),
    ],
  ),

  // 3.5 España - Época del Euro (grabadas físicamente 1999–presente)
  NumismaticEmissionRuleData(
    country: 'España',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Catedral de Santiago de Compostela',
            minYear: 1999,
            maxYear: 2100,
            material: 'Acero bañado en cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Catedral de Santiago de Compostela',
            minYear: 1999,
            maxYear: 2100,
            material: 'Acero bañado en cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Catedral de Santiago de Compostela',
            minYear: 1999,
            maxYear: 2100,
            material: 'Acero bañado en cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Miguel de Cervantes',
            minYear: 1999,
            maxYear: 2100,
            material: 'Oro nórdico',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Miguel de Cervantes',
            minYear: 1999,
            maxYear: 2100,
            material: 'Oro nórdico',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Miguel de Cervantes',
            minYear: 1999,
            maxYear: 2100,
            material: 'Oro nórdico',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Rey Juan Carlos I / Rey Felipe VI',
            minYear: 1999,
            maxYear: 2100,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Efigie del Rey Juan Carlos I / Rey Felipe VI (Circulación Estándar)',
            minYear: 1999,
            maxYear: 2100,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'IV Centenario de Don Quijote de la Mancha',
            minYear: 2005,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '50 Aniversario del Tratado de Roma',
            minYear: 2007,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '10 Años de la Unión Económica y Monetaria',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Centro Histórico de Córdoba - Mezquita-Catedral (UNESCO 2010)',
            minYear: 2010,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'La Alhambra, Generalife y Albaicín de Granada (UNESCO 2011)',
            minYear: 2011,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Catedral de Burgos (UNESCO 2012)',
            minYear: 2012,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '10 Años de los Billetes y Monedas en Euros',
            minYear: 2012,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Real Monasterio de San Lorenzo de El Escorial (UNESCO 2013)',
            minYear: 2013,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Parque Güell - Obras de Antoni Gaudí (UNESCO 2014)',
            minYear: 2014,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Proclamación de Su Majestad el Rey Felipe VI',
            minYear: 2014,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Cueva de Altamira y Arte Rupestre del Norte de España (UNESCO 2015)',
            minYear: 2015,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '30 Años de la Bandera de la Unión Europea',
            minYear: 2015,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Acueducto de Segovia (UNESCO 2016)',
            minYear: 2016,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Monumentos de Oviedo y del Reino de Asturias (UNESCO 2017)',
            minYear: 2017,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '50 Aniversario del Nacimiento del Rey Felipe VI',
            minYear: 2018,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Ciudad Vieja de Santiago de Compostela (UNESCO 2018)',
            minYear: 2018,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Murallas y Ciudad Vieja de Ávila (UNESCO 2019)',
            minYear: 2019,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Arquitectura Mudéjar de Aragón (UNESCO 2020)',
            minYear: 2020,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Ciudad Histórica de Toledo (UNESCO 2021)',
            minYear: 2021,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Parque Nacional de Garajonay (UNESCO 2022)',
            minYear: 2022,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'V Centenario de la Vuelta al Mundo de Juan Sebastián Elcano',
            minYear: 2022,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '35 Años del Programa Erasmus',
            minYear: 2022,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Ciudad Vieja de Cáceres (UNESCO 2023)',
            minYear: 2023,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Presidencia Española del Consejo de la Unión Europea',
            minYear: 2023,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Catedral, Alcázar y Archivo de Indias de Sevilla (UNESCO 2024)',
            minYear: 2024,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Bicentenario de la Policía Nacional',
            minYear: 2024,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            'Paisaje de la Luz de Madrid (UNESCO 2025)',
            minYear: 2025,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '10',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Serie Conmemorativa de Plata (Casa Real y Efemérides Nacionales)',
            minYear: 2002,
            maxYear: 2100,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '12',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Serie Conmemorativa de Plata (Casa Real y Efemérides Nacionales)',
            minYear: 2002,
            maxYear: 2010,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '20',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Serie Conmemorativa de Plata (Casa Real y Efemérides Nacionales)',
            minYear: 2010,
            maxYear: 2011,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '30',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Serie Conmemorativa de Plata (Casa Real y Efemérides Nacionales)',
            minYear: 2012,
            maxYear: 2020,
            material: 'Plata',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '40',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Serie Conmemorativa de Plata (Casa Real y Efemérides Nacionales)',
            minYear: 2021,
            maxYear: 2100,
            material: 'Plata',
          ),
        ],
      ),
    ],
  ),

  // 3.6 Unión Europea (Zona Euro, grabadas físicamente 1999–presente)
  NumismaticEmissionRuleData(
    country: 'Unión Europea',
    pieces: [
      NumismaticPieceDefinition(
        denomination: '0.01',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Euro Común (Globo Terráqueo)',
            minYear: 1999,
            maxYear: 2100,
            material: 'Acero bañado en cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.02',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Euro Común (Globo Terráqueo)',
            minYear: 1999,
            maxYear: 2100,
            material: 'Acero bañado en cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.05',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Euro Común (Globo Terráqueo)',
            minYear: 1999,
            maxYear: 2100,
            material: 'Acero bañado en cobre',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.10',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Euro Común (Mapa Europeo)',
            minYear: 1999,
            maxYear: 2100,
            material: 'Oro nórdico',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.20',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Euro Común (Mapa Europeo)',
            minYear: 1999,
            maxYear: 2100,
            material: 'Oro nórdico',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '0.50',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Euro Común (Mapa Europeo)',
            minYear: 1999,
            maxYear: 2100,
            material: 'Oro nórdico',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '1',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Común (Mapa Europeo)',
            minYear: 1999,
            maxYear: 2100,
            material: 'Bimetálica',
          ),
        ],
      ),
      NumismaticPieceDefinition(
        denomination: '2',
        currency: 'EUR',
        motifs: [
          NumismaticMotifRule(
            'Mapa de Europa / Unión Europea (Cara Común Estándar)',
            minYear: 1999,
            maxYear: 2100,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '50 Aniversario del Tratado de Roma',
            minYear: 2007,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '10 Años de la Unión Económica y Monetaria',
            minYear: 2009,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '10 Años de los Billetes y Monedas en Euros',
            minYear: 2012,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '30 Años de la Bandera de la Unión Europea',
            minYear: 2015,
            material: 'Bimetálica',
          ),
          NumismaticMotifRule(
            '35 Años del Programa Erasmus',
            minYear: 2022,
            material: 'Bimetálica',
          ),
        ],
      ),
    ],
  ),
];
