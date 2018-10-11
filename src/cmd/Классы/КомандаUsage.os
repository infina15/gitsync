Перем ЭтоWindows;

Перем ИмяКомандыGitsync;
Перем КаталогДокументации;

Процедура ОписаниеКоманды(Команда) Экспорт

    Команда.Аргумент("COMMAND", "", "Команда для вывода подробностей использования").ТСтрока().Обязательный(Ложь);

    //Команда.УстановитьДействиеПередВыполнением(ПараметрыПриложения);
    //Команда.УстановитьДействиеПослеВыполнения(ПараметрыПриложения);

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	Если ПараметрыПриложения.ЭтоСборкаEXE() Тогда
		
		Лог.Информация("Команда <usage> для собранного приложения в exe не доступна");

		Возврат;

	КонецЕсли;

    ИмяКоманды = Команда.ЗначениеАргумента("COMMAND");

    Если ПустаяСтрока(ИмяКоманды) Тогда
        ВывестиОбщееИспользование();
    Иначе
        ВывестиИспользованиеКоманды(НРег(ИмяКоманды));
    КонецЕсли;

КонецПроцедуры

Процедура ВывестиОбщееИспользование()

    ТекстОбщегоОписания = "
    |  Общее описание сценария использования:
    |
    |  Для начала выполения синхронизации необходимо выполнить подготовку рабочей копии:
    |   
    |  I Порядок настройки:
    |   
    |  1. Активизация нужных плагинов:
    |     
    |     > %1 plugins enable ИМЯПЛАГИНА
    |      или активизация всех плагинов
    |     > %1 plugins enable -a
    |    
    |     Подробные описание использования команды <plugins>: 
    |   
    |     > %1 usage plugins 
    |    
    |  2. Настройка переменных окружения (можно пропустить и указывать в строке использования): 
    |    
    |    Общие переменные окружения:
    |    *GITSYNC_WORKDIR   - рабочий каталог для команд gitsync
    |    *GITSYNC_V8VERSION - маска версии платформы (8.3, 8.3.5, 8.3.6.2299 и т.п.)
    |    *GITSYNC_TEMP      - путь к каталогу временных файлов
    |    *GITSYNC_VERSOBE   - вывод отладочной информация в процессе выполнения
    |    
    |    Дополнительные переменные окружения можно посмотреть 
    |    в справке соответствующей команды
    |   
    |  II Порядок использования:
    |   
    |  1. Создание рабочей копии (можно пропустить если уже есть):
    |   
    |    Инициализация или клонирование существующего git-репозитория и подготовка начальных данных:
    |     > %1 init 
    |      или 
    |     > %1 clone
    |    
    |    Подробные описание использования: 
    |   
    |     > %1 usage init 
    |      или 
    |     > %1 usage clone
    |   
    |  2. Установка уже синхронизированной версии (если требуется):
    |    
    |     > %1 setversion 
    |     
    |    Подробное описание использования команды <setversion>: 
    |    
    |     > %1 usage setversion
    |   
    |  3. Выполнение синхронизации хранилища 1С с git репозиторием:
    |    
    |     > %1 sync 
    |     
    |    Подробное описание использования команды <sync>: 
    |    
    |     > %1 usage sync
    |";

    ВывестиОписание(ТекстОбщегоОписания);

КонецПроцедуры

Процедура ВывестиИспользованиеКоманды(Знач ИмяКоманды)

    Если ИмяКоманды = "init"
        или ИмяКоманды = "i" Тогда
        ВывестиИспользованиеInit();
    ИначеЕсли ИмяКоманды = "clone" 
        или ИмяКоманды = "c" Тогда
        ВывестиИспользованиеClone();
    ИначеЕсли ИмяКоманды = "sync" 
        или ИмяКоманды = "s" Тогда
        ВывестиИспользованиеSync();
    ИначеЕсли ИмяКоманды = "setversion"
        или ИмяКоманды = "v" Тогда
        ВывестиИспользованиеSetVersion();
    ИначеЕсли ИмяКоманды = "plugins" 
        или ИмяКоманды = "p" Тогда
        ВывестиИспользованиеPlugins();
    Иначе
        Сообщить("Команда для подробного использования не корректная или не найдена");
        ВывестиОбщееИспользование();
    КонецЕсли;

КонецПроцедуры

Процедура ВывестиОписание(Знач ТекстОписания)
    
    Консоль = Новый Консоль();
    // ЦветТекстаКонсоли = Консоль.ЦветТекста;
    // Консоль.ЦветТекста = ЦветТекстаКонсоли;
    ИтоговаяСправка = ТекстОписания;// СтрШаблон(ТекстОписания, ИмяКомандыGitsync);

    МассивСтрокВывода = СтрРазделить(ИтоговаяСправка, Символы.ПС);

    Для каждого СтрокаВывода Из МассивСтрокВывода Цикл
        Если СтрНачинаетсяС(СокрЛП(Строкавывода),"*")  Тогда
            СтрокаВывода  =  СтрЗаменить(СтрокаВывода,"*", " ");
            
            // Консоль.ЦветТекста = ЦветаКонсоли().ЦветСписка;
   
            Консоль.ВывестиСтроку(Строкавывода);
            
            // Консоль.ЦветТекста = ЦветТекстаКонсоли;

        ИначеЕсли СтрНачинаетсяС(СокрЛП(Строкавывода),">")  Тогда
            //СтрокаВывода  =  СтрЗаменить(Строкавывода,">", " ");
            
            // Консоль.ЦветТекста = ЦветаКонсоли().ЦветКоманды;
   
            Консоль.ВывестиСтроку(Строкавывода);
            
            // Консоль.ЦветТекста = ЦветТекстаКонсоли;
        Иначе
            Консоль.ВывестиСтроку(Строкавывода);
        КонецЕсли;
    КонецЦикла;

    
    // Консоль.ЦветТекста = ЦветТекстаКонсоли;
    //Консоль.ВывестиСтроку(ИтоговаяСправка);
    Консоль = Неопределено;


КонецПроцедуры

Процедура ВывестиИспользованиеInit()
    
    ОписаниеКомандыInit = ПрочитатьФайл(ОбъединитьПути(КаталогДокументации, "init.md"));

    ВывестиОписание(ОписаниеКомандыInit);

КонецПроцедуры

Процедура ВывестиИспользованиеClone()
    
    ПодробноеОписаниеКоманды = "
    |  Подробное описание использования команды <clone>
    |   
    |  clone (синоним c) - клонирует репозиторий git и при необходимости наполняет его данными из хранилища 1С
    |  Подробную справку по параметрам см. %1 clone --help
    |  
    |  В РАЗРАБОТКЕ
    |";

    ВывестиОписание(ПодробноеОписаниеКоманды);

КонецПроцедуры

Процедура ВывестиИспользованиеSync()
    
    ПодробноеОписаниеКоманды = "
    |  Подробное описание использования команды <sync>
    |   
    |  sync (синоним s) - инициализация нового хранилища git и наполнение его данными из хранилища 1С
    |  Подробную справку по параметрам см. %1 sync --help
    |   
    |  Переменные окружения:
    |  * GITSYNC_WORKDIR  - рабочий каталог для команды
    |  * GITSYNC_STORAGE_PATH - путь к хранилищу конфигурации 1С.
    |   
    |  Примеры, использования:
    |   
    |  1. Простое использование
    |   
    |   > %1 sync C:/Хранилище_1С/ C:/work_dir/
    |   
    |   Данная команда выполнит синхронизация 
    |   версий хранилища 1С ""C:/Хранилище_1С/""
    |   в рабочем каталоге ""C:/work_dir/""
    |   
    |  2. Инциализация в текущем рабочем каталоге, 
    |   переменная окружения <GITSYNC_WORKDIR> не должна быть задана
    |   
    |   > cd C:/work_dir/
    |   > %1 sync C:/Хранилище_1С/
    |   
    |   Данная команда выполнит синхронизация 
    |   версий хранилища 1С ""C:/Хранилище_1С/""
    |   в рабочем каталоге ""C:/work_dir/""
    |  

    |";

    ВывестиОписание(ПодробноеОписаниеКоманды);

КонецПроцедуры

Процедура ВывестиИспользованиеSetVersion()
    
    ПодробноеОписаниеКоманды = "Подробное описание использования команды <setversion>
    |   
    |  setversion (синоним v) - устанавливает необходимую версию в файл VERSION
    |  Подробную справку по параметрам см. %1 setversion --help
    |  
    |  В РАЗРАБОТКЕ
    |";

    ВывестиОписание(ПодробноеОписаниеКоманды);

КонецПроцедуры

Процедура ВывестиИспользованиеPlugins()
    
    ПодробноеОписаниеКоманды = "Подробное описание использования команды <plugins>
    |   
    |  plugins (синоним p) - инициализация нового хранилища git и наполнение его данными из хранилища 1С
    |  Подробную справку по параметрам см. %1 plugins --help
    |   
    |  В РАЗРАБОТКЕ
    |";

    ВывестиОписание(ПодробноеОписаниеКоманды);

КонецПроцедуры


Функция Инициализация()

    СистемнаяИнформация = Новый СистемнаяИнформация;
    ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;

    Если ЭтоWindows Тогда
        ИмяКомандыGitsync = "gitsync";
    Иначе
        ИмяКомандыGitsync = "gitsync";
    КонецЕсли;

    КаталогДокументации = ОбъединитьПути(ОбъединитьПути(ТекущийСценарий().Каталог, "..","..", ".."),"docs");

КонецФункции

Функция ПрочитатьФайл(Знач ИмяФайла)
	
	Чтение = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
	Рез  = Чтение.Прочитать();
	Чтение.Закрыть();
	
	Возврат Рез;

КонецФункции // ПрочитатьФайл()

Функция ЦветаКонсоли() Экспорт;
    
    Цвета = Новый Структура;
    // Цвета.Вставить("ЦветСписка", ЦветКонсоли.Желтый);
    // Цвета.Вставить("ЦветКоманды", ЦветКонсоли.Зеленый);
 
    Возврат Цвета;

КонецФункции

Инициализация();