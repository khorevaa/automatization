﻿
Перем мЭтоИерархическаяВыгрузка;

Процедура ВыполнитьСборкуКонфигурации() Экспорт
	
	ЗаполнитьКоллекциюОбъектовМД();
	СкопироватьФайлыОбъектовМД();
	ПочиститьСсылкиВЗаглушках();
	СоздатьКонфигурационныеФайлы();
	
КонецПроцедуры

#Область _ // Шаг 1 - Заполняет коллекцию объектов для переноса

Процедура ЗаполнитьКоллекциюОбъектовМД()
	Состояние("Заполняем коллекцию объектов");
	
	ЗаполнитьКоллекциюОбъектовМД_Инициализация();
	ЗаполнитьКоллекциюОбъектовМД_СписокОбъектов(ФайлОписанияКонфигурации, Ложь);
	ЗаполнитьКоллекциюОбъектовМД_СписокОбъектов(ФайлРучныхЗаглушек, Истина);
	ЗаполнитьКоллекциюОбъектовМД_Заглушки();
	ЗаполнитьКоллекциюОбъектовМД_ЗаглушкиЗаглушек();
	
КонецПроцедуры


Процедура ЗаполнитьКоллекциюОбъектовМД_Инициализация()
	
	КоллекцияОбъектовМД.Очистить();
	
	КаталогИсходныхФайлов = ПутьККаталогуСоСлешем(КаталогИсходныхФайлов);
	
	мЭтоИерархическаяВыгрузка = ЭтоИерархическаяВыгрузка();
	
КонецПроцедуры
Функция ЭтоИерархическаяВыгрузка()
	
	НайденныеФайлы = НайтиФайлы(КаталогИсходныхФайлов, "Languages.");
	
	Возврат Булево(НайденныеФайлы.Количество());
	
КонецФункции

Процедура ЗаполнитьКоллекциюОбъектовМД_СписокОбъектов(ПутьКФайлу, ЭтоЗаглушка)
	Если ПустаяСтрока(ПутьКФайлу) Тогда
		Возврат;
	КонецЕсли;
	
	КопияФайлаСоСпискомОбъектов = ПутьККопииФайла(ПутьКФайлу);
	
	Если НРег(ПолучитьРасширениеФайла(КопияФайлаСоСпискомОбъектов)) = ".xml" Тогда
		ЗаполнитьКоллекциюОбъектовМД_СписокОбъектов_xml(КопияФайлаСоСпискомОбъектов, ЭтоЗаглушка);
	Иначе
		ЗаполнитьКоллекциюОбъектовМД_СписокОбъектов_ИзТабличногоДокумента(КопияФайлаСоСпискомОбъектов, ЭтоЗаглушка);
	КонецЕсли;
	
КонецПроцедуры
Процедура ЗаполнитьКоллекциюОбъектовМД_СписокОбъектов_ИзТабличногоДокумента(ПутьКФайлу, ЭтоЗаглушка)
	
	СписокЗагружаемыхОбъектов = Новый ТабличныйДокумент;
	СписокЗагружаемыхОбъектов.Прочитать(ПутьКФайлу);
	
	ТаблицаСоответствийИменТипов = ПрочитатьТаблицуИзМакета("СоответствиеРусскихИАнглийскихИменТипов");
	
	Для сч = 2 по СписокЗагружаемыхОбъектов.ВысотаТаблицы Цикл
		ТипОбъекта = СписокЗагружаемыхОбъектов.Область(сч, 1).Текст;
		ВидОбъекта = СписокЗагружаемыхОбъектов.Область(сч, 2).Текст;
		Если ПустаяСтрока(ТипОбъекта) или ПустаяСтрока(ВидОбъекта) Тогда
			Продолжить;
		КонецЕсли;
		
		НайденнаяСтрока = ТаблицаСоответствийИменТипов.Найти(ТипОбъекта);
		Если НЕ НайденнаяСтрока = Неопределено Тогда
			ТипОбъекта = НайденнаяСтрока.ТипАнглийский;
		КонецЕсли;
		
		ОбъектМД_ДобавитьВКоллекцию(ТипОбъекта, ВидОбъекта, ЭтоЗаглушка);
		
	КонецЦикла;
	
КонецПроцедуры
Функция ПрочитатьТаблицуИзМакета(ИмяМакета)
	Макет = ПолучитьМакет(ИмяМакета);
	
	ТаблицаИзМакета = Новый ТаблицаЗначений;
	Для сч = 1 по Макет.ШиринаТаблицы Цикл
		Текст = Макет.Область(1, сч).Текст;
		Если ПустаяСтрока(Текст) Тогда
			Продолжить;
		КонецЕсли;
		ТаблицаИзМакета.Колонки.Добавить(Текст);
	КонецЦикла;
	
	Для счСтр = 2 по Макет.ВысотаТаблицы Цикл
		НоваяСтрока = ТаблицаИзМакета.Добавить();
		Для счКол = 1 по ТаблицаИзМакета.Колонки.Количество() Цикл
			НоваяСтрока[счКол-1] = Макет.Область(счСтр, счКол).Текст;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТаблицаИзМакета;
КонецФункции
Процедура ЗаполнитьКоллекциюОбъектовМД_СписокОбъектов_xml(ПутьКФайлу, ЭтоЗаглушка)
	DOMОбъект = ПрочитатьDOMИзФайла(ПутьКФайлу);
	НайденныеУзлы = DOMОбъект.ПолучитьЭлементыПоИмени("xr:Item");
	Для Каждого Узел Из НайденныеУзлы Цикл
		
		Тип_Вид_Элемента = Узел.ТекстовоеСодержимое;
		Тип_Вид_Элемента = СтрЗаменить(Тип_Вид_Элемента, ".", Символы.ПС);
		
		Тип = СтрПолучитьСтроку(Тип_Вид_Элемента, 1);
		Вид = СтрПолучитьСтроку(Тип_Вид_Элемента, 2);
		
		ОбъектМД_ДобавитьВКоллекцию(Тип, Вид, ЭтоЗаглушка);
		
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьКоллекциюОбъектовМД_Заглушки()
	
	ЗаполнитьКоллекциюОбъектовМД_Заглушки_Configuration();
	ЗаполнитьКоллекциюОбъектовМД_Заглушки_xml();
	ЗаполнитьКоллекциюОбъектовМД_Заглушки_form_bin();
	
КонецПроцедуры
Процедура ЗаполнитьКоллекциюОбъектовМД_Заглушки_Configuration()
	
	ФайлДереваКонфигурации = ПутьККопииФайла(КаталогИсходныхФайлов + "Configuration.xml");
	ДеревоКонфигурацииDOM = ПрочитатьDOMИзФайла(ФайлДереваКонфигурации);
	ОчиститьДочерниеУзлыDOMОбъекта(ДеревоКонфигурацииDOM, "ChildObjects");
	ЗаписатьDOMОбъектВФайл(ДеревоКонфигурацииDOM, ФайлДереваКонфигурации);
	
	МассивОбъектов = ПолучитьУпомянутыеОбъектыВФайле_xml(ФайлДереваКонфигурации);
	КоллекцияОбъектовМД_ЗаполнитьИзМассива(МассивОбъектов, Истина);
	
КонецПроцедуры
Процедура ЗаполнитьКоллекциюОбъектовМД_Заглушки_xml()
	
	Отбор = Новый Структура("ЭтоЗаглушка", Ложь);
	НайденныеСтроки = КоллекцияОбъектовМД.НайтиСтроки(Отбор);
	Для Каждого Строка из НайденныеСтроки Цикл
		
		НайденныеФайлы = ОбъектМД_НайтиВсеФайлыXML(Строка, КаталогИсходныхФайлов);
		Для каждого НайденныйФайл из НайденныеФайлы Цикл
			
			МассивОбъектов = ПолучитьУпомянутыеОбъектыВФайле_xml(НайденныйФайл.ПолноеИмя);
			КоллекцияОбъектовМД_ЗаполнитьИзМассива(МассивОбъектов, Истина);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры
Процедура ЗаполнитьКоллекциюОбъектовМД_Заглушки_form_bin()
	
	ТаблицаГуидовОбъектовКонфигурации = ПолучитьГуидыОбъектовКонфигурации();
	
	Отбор = Новый Структура("ЭтоЗаглушка", Ложь);
	НайденныеСтроки = КоллекцияОбъектовМД.НайтиСтроки(Отбор);
	
	Для Каждого Строка из НайденныеСтроки Цикл
		
		НайденныеФайлы = ОбъектМД_НайтиФайлыОписанияОбычныхФормОбъекта(Строка, КаталогИсходныхФайлов);
		Для каждого НайденныйФайл из НайденныеФайлы Цикл
			
			МассивОбъектов = ПолучитьУпомянутыеОбъектыВФайле_Form(НайденныйФайл.ПолноеИмя, ТаблицаГуидовОбъектовКонфигурации);
			КоллекцияОбъектовМД_ЗаполнитьИзМассива(МассивОбъектов, Истина);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры
Функция ПолучитьУпомянутыеОбъектыВФайле_xml(ПутьКФайлу)
	Состояние("Поиск связанных объектов для " + ПутьКФайлу);
	мУпомянутыеОбъекты = Новый Массив;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ПутьКФайлу);
	
	мШаблоныПоиска = Новый Массив;
	мШаблоныПоиска.Добавить("Interface");
	мШаблоныПоиска.Добавить("Style");
	мШаблоныПоиска.Добавить("Language");
	мШаблоныПоиска.Добавить("CommonForm");
	мШаблоныПоиска.Добавить("Catalog");
	мШаблоныПоиска.Добавить("AccumulationRegister");
	мШаблоныПоиска.Добавить("InformationRegister");
	мШаблоныПоиска.Добавить("AccountingRegister");
	мШаблоныПоиска.Добавить("ChartOfAccounts");
	мШаблоныПоиска.Добавить("ChartOfCharacteristicTypes");
	мШаблоныПоиска.Добавить("Role");
	мШаблоныПоиска.Добавить("Task");
	мШаблоныПоиска.Добавить("SessionParameter");
	мШаблоныПоиска.Добавить("SettingsStorage");
	мШаблоныПоиска.Добавить("Document");
	мШаблоныПоиска.Добавить("CommonPicture");
	мШаблоныПоиска.Добавить("Report");
	мШаблоныПоиска.Добавить("Enum");
	мШаблоныПоиска.Добавить("CommandGroup");
	мШаблоныПоиска.Добавить("StyleItem");
	мШаблоныПоиска.Добавить("DataProcessor");
	мШаблоныПоиска.Добавить("BusinessProcess");
	мШаблоныПоиска.Добавить("FunctionalOption");
	мШаблоныПоиска.Добавить("CommonCommand");
	мШаблоныПоиска.Добавить("Constant");
	мШаблоныПоиска.Добавить("ExchangePlan");

	ИсходныйТекст = ТекстовыйДокумент.ПолучитьТекст();
	Для каждого ШаблонПоиска из мШаблоныПоиска Цикл
		Текст = ИсходныйТекст;
		Подстрока = ">" + ШаблонПоиска + ".";
		ПозицияВСтроке = Найти(Текст, Подстрока);
		Пока ПозицияВСтроке Цикл
			Текст = Сред(Текст, ПозицияВСтроке + 1);
			УпомянутыйОбъект = Лев(Текст, Найти(Текст, "<")-1);
			Если СтрЧислоВхождений(УпомянутыйОбъект, ".") = 1 Тогда
				мУпомянутыеОбъекты.Добавить(УпомянутыйОбъект);
			ИначеЕсли СтрЧислоВхождений(УпомянутыйОбъект, ".") > 1 Тогда
				УпомянутыйОбъект = СтрЗаменить(УпомянутыйОбъект, ".", Символы.ПС);
				мУпомянутыеОбъекты.Добавить(
						СтрПолучитьСтроку(УпомянутыйОбъект, 1)
						+"."
						+СтрПолучитьСтроку(УпомянутыйОбъект, 2));
			КонецЕсли;
			
			ПозицияВСтроке = Найти(Текст, Подстрока);
		КонецЦикла;
		
	КонецЦикла;
	
	
	Текст = ИсходныйТекст;
	Текст = СтрЗаменить(Текст, "d4p1:", "cfg:");
	Текст = СтрЗаменить(Текст, "xmlns:d8p1=""http://v8.1c.ru/8.1/data/ui/style"" xsi:type=""v8ui:Color"">d8p1:", ">cfg:StyleItem.");
	Текст = СтрЗаменить(Текст, "xsi:type=""v8ui:Color"">style:", ">cfg:StyleItem.");
	Текст = СтрЗаменить(Текст, "cfg:Characteristic.", "cfg:ChartOfCharacteristicTypes.");
	Текст = СтрЗаменить(Текст, "cfg:InformationRegisterRecordManager.", "cfg:InformationRegister.");
	Текст = СтрЗаменить(Текст, "cfg:DocumentRef<", "<");
	Текст = СтрЗаменить(Текст, "cfg:CatalogRef<", "<");
	Текст = СтрЗаменить(Текст, "cfg:DynamicList<", "<");
	Текст = СтрЗаменить(Текст, "cfg:Filter<", "<");
	Текст = СтрЗаменить(Текст, "cfg:ReportBuilder<", "<");
	Текст = СтрЗаменить(Текст, "cfg:AnyRef<", "<");
	Подстрока = ">cfg:";
	ПозицияВСтроке = Найти(Текст, Подстрока);
	Пока ПозицияВСтроке Цикл
		Текст = Сред(Текст, ПозицияВСтроке + 1);
		ИмяОбъекта = Лев(Текст, Найти(Текст, "<")-1);
		ИмяОбъекта = СтрЗаменить(ИмяОбъекта, "cfg:", "");
		ИмяОбъекта = СтрЗаменить(ИмяОбъекта, "Ref.", ".");
		ИмяОбъекта = СтрЗаменить(ИмяОбъекта, "Object.", ".");
		мУпомянутыеОбъекты.Добавить(ИмяОбъекта);
		
		ПозицияВСтроке = Найти(Текст, Подстрока);
	КонецЦикла;
	
	Текст = ИсходныйТекст;
	МаркерНачала = "<xr:Value name=""";
	Текст = СтрЗаменить(Текст, "<Item name=""StyleItem.", МаркерНачала + "StyleItem.");
	ПозицияВСтроке = Найти(Текст, МаркерНачала);
	Пока ПозицияВСтроке Цикл
		Текст = Сред(Текст, ПозицияВСтроке + СтрДлина(МаркерНачала));
		ИмяОбъекта = Лев(Текст, Найти(Текст, """>")-1);
		мУпомянутыеОбъекты.Добавить(ИмяОбъекта);
		
		ПозицияВСтроке = Найти(Текст, МаркерНачала);
	КонецЦикла;
	
	
	Возврат мУпомянутыеОбъекты;
КонецФункции
Функция ПолучитьУпомянутыеОбъектыВФайле_Form(ПутьКФайлу, ТаблицаГуидовОбъектов)
	Состояние("Поиск связанных объектов для " + ПутьКФайлу);
	УпомянутыеОбъекты = Новый Массив;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ПутьКФайлу);
	ИсходныйТекст = ТекстовыйДокумент.ПолучитьТекст();
	
	Текст = ИсходныйТекст;
	Текст = СтрЗаменить(Текст, ",", Символы.ПС);
	Текст = СтрЗаменить(Текст, "{", Символы.ПС);
	Текст = СтрЗаменить(Текст, "}", Символы.ПС);
	
	RegExp = Новый COMОбъект("VBScript.RegExp");
	RegExp.Global = Истина;
	RegExp.MultiLine = Истина;
	
	RegExp.Pattern = "^\S{36}$";
	Matches = RegExp.Execute(Текст);
	
	Для Счетчик = 0 По Matches.Count - 1 Цикл 
		ГуидОбъекта = Matches.Item(Счетчик).Value;
		
		Отбор = Новый Структура("Гуид", ГуидОбъекта);
		НайденныеСтроки = ТаблицаГуидовОбъектов.НайтиСтроки(Отбор);
		Для каждого Строка из НайденныеСтроки Цикл
			УпомянутыеОбъекты.Добавить(Строка.ИмяОбъектаКонфигурации);
		КонецЦикла;
	КонецЦикла;
	
	
	Возврат УпомянутыеОбъекты;
КонецФункции
Функция ПолучитьГуидыОбъектовКонфигурации()
	ТаблицаГуидов = Новый ТаблицаЗначений;
	ТаблицаГуидов.Колонки.Добавить("Гуид");
	ТаблицаГуидов.Колонки.Добавить("ИмяОбъектаКонфигурации");
	
	КопияФайлаОписанияКонфигурации = ПутьККопииФайла(КаталогИсходныхФайлов + "Configuration.xml");
	ОбъектDOM = ПрочитатьDOMИзФайла(КопияФайлаОписанияКонфигурации);
	
	ОбъектыКонфигурации = Новый ТаблицаЗначений;
	ОбъектыКонфигурации.Колонки.Добавить("Тип");
	ОбъектыКонфигурации.Колонки.Добавить("Вид");
	УзлыОбъектов = ОбъектDOM.ПолучитьЭлементыПоИмени("ChildObjects")[0].ДочерниеУзлы;
	Для каждого Узел из УзлыОбъектов Цикл
		Если НЕ Узел.ТипУзла = ТипУзлаDOM.Элемент Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ОбъектыКонфигурации.Добавить();
		НоваяСтрока.Тип = Узел.ИмяЭлемента;
		НоваяСтрока.Вид = Узел.ТекстовоеСодержимое;
		
	КонецЦикла;
	
	RegExp = Новый COMОбъект("VBScript.RegExp");
	RegExp.Global = Истина;
	RegExp.MultiLine = Истина;
	
	RegExp.Pattern = """\S{36}""";
	
	
	СчетчикДляВыводаСостояния = 0;
	Для каждого Строка из ОбъектыКонфигурации Цикл
		СчетчикДляВыводаСостояния = СчетчикДляВыводаСостояния+1;
		Если СчетчикДляВыводаСостояния%50 = 0 Тогда
			Состояние("Построение таблицы гуидов: " + СчетчикДляВыводаСостояния + "/" + ОбъектыКонфигурации.Количество());
		КонецЕсли;
		
		Если мЭтоИерархическаяВыгрузка Тогда
			ИмяФайла = КаталогИсходныхФайлов + ПолучитьТипВоМножественномЧисле(Строка.Тип)+ ПолучитьРазделительПути() + Строка.Вид + ".xml";
		Иначе
			ИмяФайла = КаталогИсходныхФайлов + Строка.Тип + "." + Строка.Вид + ".xml";
		КонецЕсли;
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ИмяФайла);
		Текст = ТекстовыйДокумент.ПолучитьТекст();
		
		Matches = RegExp.Execute(Текст);
		
		Для Счетчик = 0 По Matches.Count - 1 Цикл 
			ГуидОбъекта = Matches.Item(Счетчик).Value;
			ГуидОбъекта = СтрЗаменить(ГуидОбъекта, """", "");
			
			НоваяСтрока = ТаблицаГуидов.Добавить();
			НоваяСтрока.Гуид = ГуидОбъекта;
			НоваяСтрока.ИмяОбъектаКонфигурации = Строка.Тип + "." + Строка.Вид;
		КонецЦикла;
		
	КонецЦикла;
	
	
	ТаблицаГуидов.Индексы.Добавить("Гуид");
	Возврат ТаблицаГуидов;
	
КонецФункции

Процедура ЗаполнитьКоллекциюОбъектовМД_ЗаглушкиЗаглушек()
	
	ЗаполнитьКоллекциюОбъектовМД_ЗаглушкиЗаглушек_ПоКлючевомуТегу();
	ЗаполнитьКоллекциюОбъектовМД_ЗаглушкиЗаглушек_РегистрыСРегистраторами();
	
КонецПроцедуры
Процедура ЗаполнитьКоллекциюОбъектовМД_ЗаглушкиЗаглушек_ПоКлючевомуТегу()
	Состояние("Заполнение заглушек по ключевым тегам");
	
	МассивЗаглушек = Новый Массив;
	
	КлючевыеСлова = ПрочитатьТаблицуИзМакета("КлючевыеТегиЗаглушек");
	Для Каждого СтрокаКлючевыхСлов Из КлючевыеСлова Цикл
	
		Отбор = Новый Структура;
		Отбор.Вставить("ЭтоЗаглушка", Истина);
		Отбор.Вставить("Тип",СтрокаКлючевыхСлов.Тип);
		НайденныеСтроки = КоллекцияОбъектовМД.НайтиСтроки(Отбор);
		Для Каждого Строка Из НайденныеСтроки Цикл
			
			НайденныеФайлы = ОбъектМД_НайтиФайлОписанияОбъекта(Строка, КаталогИсходныхФайлов);
			ПутьКФайлу = НайденныеФайлы[0].ПолноеИмя;
			
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
			ТекстовыйДокумент.Прочитать(ПутьКФайлу);
			Текст = ТекстовыйДокумент.ПолучитьТекст();
			
			ИмяУзла = "<"+СтрокаКлючевыхСлов.ИмяУзла + ">";
			Поз = Найти(Текст, ИмяУзла);
			Если Поз = 0 Тогда
				Продолжить;
			КонецЕсли;
			Текст = Сред(Текст, Поз+СтрДлина(ИмяУзла));
			ИмяОбъекта = ПолучитьСловоДоРазделителя(Текст, "<");
			МассивЗаглушек.Добавить(ИмяОбъекта);
		КонецЦикла;
	КонецЦикла;
	
	КоллекцияОбъектовМД_ЗаполнитьИзМассива(МассивЗаглушек, Истина);
КонецПроцедуры
Функция ПолучитьСловоДоРазделителя(Строка, Разделитель)
	Возврат  Лев(Строка, Найти(Строка,Разделитель)-СтрДлина(Разделитель));
КонецФункции
Процедура ЗаполнитьКоллекциюОбъектовМД_ЗаглушкиЗаглушек_РегистрыСРегистраторами()
	Состояние("Получение заглушек для регистров с регистраторами");
	
	
	ДокументыИРегистраторы = ПолучитьТаблицуПересеченияДокументовИРегистров();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПОДСТРОКА(т.Вид, 1, 150) КАК Вид,
	|	ПОДСТРОКА(т.Тип, 1, 150) КАК Тип
	|ПОМЕСТИТЬ тчКоллекцияОбъектовМД
	|ИЗ
	|	&тчКоллекцияОбъектовМД КАК т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПОДСТРОКА(т.Документ, 1, 150) КАК Документ,
	|	ПОДСТРОКА(т.Регистр, 1, 150) КАК Регистр
	|ПОМЕСТИТЬ втУпомянутыеРегистрыИИхРегистраторы
	|ИЗ
	|	&тДокументыИРегистраторы КАК т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	т.Регистр,
	|	МАКСИМУМ(т.Документ) КАК Документ
	|ИЗ
	|	втУпомянутыеРегистрыИИхРегистраторы КАК т
	|ГДЕ
	|	ПОДСТРОКА(т.Регистр, 1, 150) В
	|			(ВЫБРАТЬ
	|				тч.Тип + ""."" + тч.Вид
	|			ИЗ
	|				тчКоллекцияОбъектовМД КАК тч)
	|	И НЕ т.Регистр В
	|				(ВЫБРАТЬ
	|					р.Регистр
	|				ИЗ
	|					втУпомянутыеРегистрыИИхРегистраторы КАК р
	|						ВНУТРЕННЕЕ СОЕДИНЕНИЕ тчКоллекцияОбъектовМД КАК тч
	|						ПО
	|							р.Документ = тч.Тип + ""."" + тч.Вид)
	|
	|СГРУППИРОВАТЬ ПО
	|	т.Регистр");
	Запрос.УстановитьПараметр("тчКоллекцияОбъектовМД", КоллекцияОбъектовМД.Выгрузить());
	Запрос.УстановитьПараметр("тДокументыИРегистраторы", ДокументыИРегистраторы);
	
	ТаблицаИзЗапроса = Запрос.Выполнить().Выгрузить();
	ТаблицаИзЗапроса.Свернуть("Документ");
	МассивОбъектов = ТаблицаИзЗапроса.ВыгрузитьКолонку("Документ");
	
	КоллекцияОбъектовМД_ЗаполнитьИзМассива(МассивОбъектов, Истина);
	
КонецПроцедуры
Функция ПолучитьТаблицуПересеченияДокументовИРегистров()
	РегистрыИРегистраторы = Новый ТаблицаЗначений;
	РегистрыИРегистраторы.Колонки.Добавить("Регистр", Новый ОписаниеТипов("Строка"));
	РегистрыИРегистраторы.Колонки.Добавить("Документ", Новый ОписаниеТипов("Строка"));
	
	RegExp = Новый COMОбъект("VBScript.RegExp");
	RegExp.Global = Истина;
	RegExp.MultiLine = Истина;
	
	Если мЭтоИерархическаяВыгрузка Тогда
		КаталогПоиска = КаталогИсходныхФайлов + "Documents";
		Маска = "*.xml";
	Иначе
		КаталогПоиска = КаталогИсходныхФайлов;
		Маска = "Document.*.xml";
	КонецЕсли;
	НайденныеФайлы = НайтиФайлы(КаталогПоиска, Маска);
	
	СчетчикСостояния = 0;
	Для Каждого Файл Из НайденныеФайлы Цикл
		СчетчикСостояния=СчетчикСостояния+1;
		Если СчетчикСостояния%20 = 0 Тогда
			Состояние("Подготовка таблицы пересечения документов и регистров: " + СчетчикСостояния + "/" + НайденныеФайлы.Количество());
		КонецЕсли;
		Если НЕ мЭтоИерархическаяВыгрузка И СтрЧислоВхождений(Файл.ПолноеИмя, ".") <> 2 Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(Файл.ПолноеИмя);
		Текст = ТекстовыйДокумент.ПолучитьТекст();
		
		RegExp.Pattern = "(\<RegisterRecords>)[\S|\n| |\t|\<|\>|\:|\""|\.|\/|\=]*(?=\</RegisterRecords>)";
		Matches = RegExp.Execute(Текст);
		Если Matches.Count = 0 Тогда
			Продолжить;
		КонецЕсли;
	
		Текст = Matches.Item(0).Value;
		Текст = СтрЗаменить(Текст, "<RegisterRecords>", Символы.ПС);
		Текст = СтрЗаменить(Текст, "</RegisterRecords>", Символы.ПС);
		Текст = СтрЗаменить(Текст, "<xr:Item xsi:type=""xr:MDObjectRef"">", Символы.ПС);
		Текст = СтрЗаменить(Текст, "</xr:Item>", Символы.ПС);
		
		Для сч = 1 По СтрЧислоСтрок(Текст) Цикл
			Значение = СтрПолучитьСтроку(Текст, сч);
			Значение = СокрЛП(Значение);
			Если ПустаяСтрока(Значение) Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = РегистрыИРегистраторы.Добавить();
			НоваяСтрока.Регистр =  Значение;
			НоваяСтрока.Документ = Файл.ИмяБезРасширения;
			Если мЭтоИерархическаяВыгрузка Тогда
				НоваяСтрока.Документ = "Document." + НоваяСтрока.Документ;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат РегистрыИРегистраторы;
КонецФункции


#КонецОбласти

#Область _ // Шаг 2 - Копирует файлы в каталог сборки

Процедура СкопироватьФайлыОбъектовМД()
	Состояние("Копируем файлы");

	
	КаталогСборки = ПутьККаталогуСоСлешем(КаталогСборки);
	
	УдалитьФайлы(КаталогСборки, "*");
	
	СкопироватьФайлыОбъектовМД_СоздатьКаталогиТипов();
	НесуществующиеОбъекты = Новый Массив;
	
	Для каждого Строка из КоллекцияОбъектовМД Цикл
		
		СкопировалсяХотьОдинФайл = ОбъектМД_СкопироватьФайлы(Строка);
		
		Если СкопировалсяХотьОдинФайл = Ложь Тогда
			НесуществующиеОбъекты.Добавить(Строка);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Строка из НесуществующиеОбъекты Цикл
		Если Найти("abcdefghijklmnopqrstuvwxyz", Нрег(Лев(Строка.Вид, 1))) = 0 Тогда // костыль. Считаем, что если объект начинается с английской буквы, то он системный и не выдаем предупреждения. Актуально для элементов стилей.
			ТекстСообщения = "Не удалось найти файлы объекта: " + Строка.Тип + "." + Строка.Вид;
			Если Строка.ЭтоЗаглушка Тогда
				ТекстСообщения = ТекстСообщения + "(заглушка)";
			КонецЕсли;
			Сообщить(ТекстСообщения);
		КонецЕсли;
		КоллекцияОбъектовМД.Удалить(Строка);
	КонецЦикла;
	
	СкопироватьФайлыОбъектовМД_СкопироватьМодулиПриложения();
	
КонецПроцедуры
Процедура СкопироватьФайлыОбъектовМД_СоздатьКаталогиТипов()
	
	Если НЕ ЭтоИерархическаяВыгрузка() Тогда
		Возврат;
	КонецЕсли;
	
	ТипыОбъектов = КоллекцияОбъектовМД.Выгрузить(,"ТипВоМножественномЧисле");
	ТипыОбъектов.Свернуть("ТипВоМножественномЧисле");
	
	Для Каждого Строка Из ТипыОбъектов Цикл
		СоздатьКаталог(КаталогСборки + Строка.ТипВоМножественномЧисле);
	КонецЦикла;
	
КонецПроцедуры
Процедура СкопироватьФайлыОбъектовМД_СкопироватьМодулиПриложения()
	
	Если мЭтоИерархическаяВыгрузка Тогда
		КаталогМодулей = КаталогСборки + "Ext" + ПолучитьРазделительПути();
		СоздатьКаталог(КаталогМодулей);
		Маска = "*.bsl";
		КаталогПоиска = КаталогИсходныхФайлов + "Ext" + ПолучитьРазделительПути();
	Иначе
		КаталогМодулей = КаталогСборки;
		Маска = "Configuration.*.txt";
		КаталогПоиска = КаталогИсходныхФайлов;
	КонецЕсли;
	
	НайденныеФайлы = НайтиФайлы(КаталогПоиска, Маска);
	Для каждого Файл из НайденныеФайлы Цикл
		ИмяФайлаПриемника = КаталогМодулей + Файл.Имя;
		КопироватьФайл(Файл.ПолноеИмя, ИмяФайлаПриемника);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область _ // Шаг 3 - Обработка скопированных файлов

Процедура ПочиститьСсылкиВЗаглушках()
	Состояние("Чистим ссылки в заглушках");
	
	ШаблоныУдаления = ПрочитатьТаблицуИзМакета("ШаблоныУдаления").ВыгрузитьКолонку("ИмяУзла");
	ШаблоныОчистки = ПрочитатьТаблицуИзМакета("ШаблоныОчистки").ВыгрузитьКолонку("ИмяУзла");
	
	Отбор = Новый Структура("ЭтоЗаглушка", Истина);
	НайденныеСтроки = КоллекцияОбъектовМД.НайтиСтроки(Отбор);
	
	Для каждого Строка из НайденныеСтроки Цикл
		
		Если Строка.Тип = "Enum" Тогда
			Продолжить;
		ИначеЕсли Строка.Тип = "StyleItem" Тогда
			Продолжить;
		КонецЕсли;
		
		НайденныеФайлы = ОбъектМД_НайтиВсеФайлыXML(Строка, КаталогСборки);
		
		Если НайденныеФайлы.Количество() = 0 Тогда
			Сообщить("Не найдены файлы для : " + Строка.Тип + "." + Строка.Вид);
			Продолжить;
		КонецЕсли;
		
		Для каждого ФайлОбъекта из НайденныеФайлы Цикл
			
			ОбъектDOM = ПрочитатьDOMИзФайла(ФайлОбъекта.ПолноеИмя);
			
			ПочиститьСсылкиВЗаглушках_УдалитьУзлыПоШаблону(ОбъектDOM, ШаблоныУдаления);
			
			ПочиститьСсылкиВЗаглушках_ОчиститьУзлыПоШаблону(ОбъектDOM, ШаблоныОчистки);
			
			ЗаписатьDOMОбъектВФайл(ОбъектDOM, ФайлОбъекта.ПолноеИмя);
		
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры
Процедура ПочиститьСсылкиВЗаглушках_УдалитьУзлыПоШаблону(ОбъектDOM, ШаблоныУдаления)
	
	Для каждого Шаблон из ШаблоныУдаления Цикл
		НайденныеУзлы = ОбъектDOM.ПолучитьЭлементыПоИмени(Шаблон);
		Для сч = -НайденныеУзлы.Количество() по -1 Цикл
			НайденныйУзел = НайденныеУзлы[-сч-1];
			Если Шаблон = "v8:Type" Тогда
				Если Найти(НайденныйУзел.ТекстовоеСодержимое, ".") = 0 Тогда
					Продолжить;
				КонецЕсли;
				ТипВид = СтрЗаменить(НайденныйУзел.ТекстовоеСодержимое, "cfg:", "");
				ТипВид = СтрЗаменить(ТипВид, "Object.", ".");
				Если ОбъектМД_ПринадлежитКоллекции(ТипВид) Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			РодительскийУзел = НайденныйУзел.РодительскийУзел;
			РодительскийУзел.УдалитьДочерний(НайденныйУзел);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры
Процедура ПочиститьСсылкиВЗаглушках_ОчиститьУзлыПоШаблону(ОбъектDOM, ШаблоныОчистки)
	
	Для каждого Шаблон из ШаблоныОчистки Цикл
		мНайденныеУзлы = ОбъектDOM.ПолучитьЭлементыПоИмени(Шаблон);
		Для сч = -мНайденныеУзлы.Количество() по -1 Цикл
			НайденныйУзел = мНайденныеУзлы[-сч-1];
			
			Если ОбъектМД_ПринадлежитКоллекции(НайденныйУзел.ТекстовоеСодержимое) Тогда
				Продолжить;
			КонецЕсли;
			
			КоличествоУзлов = НайденныйУзел.ДочерниеУзлы.Количество();
			Для счУдаляемыеУзлы = -КоличествоУзлов по -1 Цикл
				УдаляемыйУзел = НайденныйУзел.ДочерниеУзлы[-счУдаляемыеУзлы-1];
				Если НайденныйУзел.ИмяЭлемента = "Owners" 
						И ОбъектМД_ПринадлежитКоллекции(УдаляемыйУзел.ТекстовоеСодержимое) Тогда
				ИначеЕсли НайденныйУзел.ИмяЭлемента = "BasedOn" 
						И ОбъектМД_ПринадлежитКоллекции(УдаляемыйУзел.ТекстовоеСодержимое) Тогда
					Продолжить;
				ИначеЕсли НайденныйУзел.ИмяЭлемента = "RegisterRecords" 
						И ОбъектМД_ПринадлежитКоллекции(УдаляемыйУзел.ТекстовоеСодержимое) Тогда
					Продолжить;
				ИначеЕсли УдаляемыйУзел.Префикс = "v8" И Найти(УдаляемыйУзел.ТекстовоеСодержимое, ".")=0 Тогда
					Продолжить;
				КонецЕсли; 
				НайденныйУзел.УдалитьДочерний(УдаляемыйУзел);
			КонецЦикла;
			
			Если ПустаяСтрока(НайденныйУзел.Префикс) И НЕ НайденныйУзел.ЕстьДочерниеУзлы() Тогда
				НовыйУзел = НайденныйУзел.КлонироватьУзел(Ложь);
				РодительскийУзел = НайденныйУзел.РодительскийУзел;
				РодительскийУзел.ЗаменитьДочерний(НовыйУзел, НайденныйУзел);
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

#Область _ // Шаг 4 - Создание служебных файлов (конфигурации и подсистем)

Процедура СоздатьКонфигурационныеФайлы()
	Состояние("Подготавливаем служебные файлы");
	
	СоздатьКонфигурационныеФайлы_Дерево();
	СоздатьКонфигурационныеФайлы_Подсистемы();
КонецПроцедуры

Процедура СоздатьКонфигурационныеФайлы_Дерево()
	
	ДеревоКонфигурацииDOM = ПрочитатьDOMИзФайла(КаталогИсходныхФайлов + "Configuration.xml");
	
	ОчиститьДочерниеУзлыDOMОбъекта(ДеревоКонфигурацииDOM, "ChildObjects");
	
	Отбор = Новый Структура("ЭтоЗаглушка", Ложь);
	СоздатьКонфигурационныеФайлы_Дерево_ДополнитьПоОтбору(ДеревоКонфигурацииDOM, Отбор);
	
	ДобавитьКомментарийВДеревоОбъектов(ДеревоКонфигурацииDOM, "ЗАГЛУШКИ");
	
	Отбор = Новый Структура("ЭтоЗаглушка", Истина);
	СоздатьКонфигурационныеФайлы_Дерево_ДополнитьПоОтбору(ДеревоКонфигурацииDOM, Отбор);
	
	ДобавитьПодсистемуВДеревоОбъектов(ДеревоКонфигурацииDOM, "ПереносимыеОбъекты");
	ДобавитьПодсистемуВДеревоОбъектов(ДеревоКонфигурацииDOM, "Заглушки");
	
	ЗаписатьDOMОбъектВФайл(ДеревоКонфигурацииDOM, КаталогСборки + "Configuration.xml");
	
КонецПроцедуры
Процедура СоздатьКонфигурационныеФайлы_Дерево_ДополнитьПоОтбору(ДеревоКонфигурацииDOM, Отбор)
	
	КорневойУзелОбъектов = ДеревоКонфигурацииDOM.ПолучитьЭлементыПоИмени("ChildObjects")[0];
	
	мНайденныеСтроки = КоллекцияОбъектовМД.НайтиСтроки(Отбор);
	Для каждого Строка из мНайденныеСтроки Цикл
		
		НовыйУзел = ДеревоКонфигурацииDOM.СоздатьЭлемент(Строка.Тип);
		НовыйУзел.ТекстовоеСодержимое = Строка.Вид;
		
		КорневойУзелОбъектов.ДобавитьДочерний(НовыйУзел);
	КонецЦикла;
	
КонецПроцедуры
Процедура ДобавитьКомментарийВДеревоОбъектов(ДеревоКонфигурацииDOM, Комментарий)
	
	КорневойУзелОбъектов = ДеревоКонфигурацииDOM.ПолучитьЭлементыПоИмени("ChildObjects")[0];
	НовыйУзел = ДеревоКонфигурацииDOM.СоздатьКомментарий(Комментарий);
	КорневойУзелОбъектов.ДобавитьДочерний(НовыйУзел);
	
КонецПроцедуры
Процедура ДобавитьПодсистемуВДеревоОбъектов(ДеревоКонфигурацииDOM, ИмяПодсистемы)
	
	ИмяЭлемента = "Subsystem";
	НовыйУзел = ДеревоКонфигурацииDOM.СоздатьЭлемент(ИмяЭлемента);
	НовыйУзел.ТекстовоеСодержимое = ИмяПодсистемы;
	КорневойУзелОбъектов = ДеревоКонфигурацииDOM.ПолучитьЭлементыПоИмени("ChildObjects")[0];
	КорневойУзелОбъектов.ДобавитьДочерний(НовыйУзел);
	
КонецПроцедуры

Процедура СоздатьКонфигурационныеФайлы_Подсистемы()
	
	СоздатьКонфигурационныеФайлы_Подсистемы_СоздатьКаталогПодсистем();
	
	ИмяПодсистемы = "ПереносимыеОбъекты";
	Отбор = Новый Структура("ЭтоЗаглушка", Ложь);
	СоздатьКонфигурационныеФайлы_Подсистемы_СоздатьФайлПоОтбору(ИмяПодсистемы, Отбор);
	
	ИмяПодсистемы = "Заглушки";
	Отбор = Новый Структура("ЭтоЗаглушка", Истина);
	СоздатьКонфигурационныеФайлы_Подсистемы_СоздатьФайлПоОтбору(ИмяПодсистемы, Отбор);
	
КонецПроцедуры
Процедура СоздатьКонфигурационныеФайлы_Подсистемы_СоздатьКаталогПодсистем()
	
	Если НЕ мЭтоИерархическаяВыгрузка Тогда
		Возврат;
	КонецЕсли;
	
	КаталогПодсистем = КаталогСборки + "Subsystems";
	Файл = Новый Файл(КаталогПодсистем);
	Если Файл.Существует() Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьКаталог(КаталогПодсистем);
	
КонецПроцедуры
Процедура СоздатьКонфигурационныеФайлы_Подсистемы_СоздатьФайлПоОтбору(ИмяПодсистемы, Отбор)
	Макет = ПолучитьМакет("ШаблонПодсистемы");
	ОбъектDOM = ПрочитатьDOMИзСтроки(Макет.ПолучитьТекст());
	
	ОбъектDOM.ПолучитьЭлементыПоИмени("Subsystem")[0].УстановитьАтрибут("uuid", Строка(Новый УникальныйИдентификатор()));
	ОбъектDOM.ПолучитьЭлементыПоИмени("Name")[0].ТекстовоеСодержимое = ИмяПодсистемы;
	
	РодительскийУзел = ОбъектDOM.ПолучитьЭлементыПоИмени("Content")[0];
	Узел_Состав = РодительскийУзел.ДочерниеУзлы[0];
	НайденныеСтроки = КоллекцияОбъектовМД.НайтиСтроки(Отбор);
	Для каждого Строка из НайденныеСтроки Цикл
		НовыйУзел = Узел_Состав.КлонироватьУзел(Истина);
		РодительскийУзел.ВставитьПеред(НовыйУзел, Узел_Состав);
		НовыйУзел.ТекстовоеСодержимое = Строка.Тип + "." + Строка.Вид;
	КонецЦикла;
	
	РодительскийУзел.УдалитьДочерний(Узел_Состав);
	
	Если мЭтоИерархическаяВыгрузка Тогда
		ПутьФайлаПодсистемы = КаталогСборки + "Subsystems" + ПолучитьРазделительПути()+ ИмяПодсистемы + ".xml";
	Иначе
		ПутьФайлаПодсистемы = КаталогСборки + "Subsystem."+ИмяПодсистемы+".xml";
	КонецЕсли;
	
	ЗаписатьDOMОбъектВФайл(ОбъектDOM, ПутьФайлаПодсистемы);
	
КонецПроцедуры

#КонецОбласти


#Область _ // ОбъектМД и КоллекцияОбъектовМД

Процедура ОбъектМД_ДобавитьВКоллекцию(Тип, Вид, ЭтоЗаглушка)
	Если ПустаяСтрока(Вид) Тогда
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = КоллекцияОбъектовМД.Добавить();
	НоваяСтрока.Тип = Тип;
	НоваяСтрока.Вид = Вид;
	НоваяСтрока.ЭтоЗаглушка = ЭтоЗаглушка;
	НоваяСтрока.ТипВоМножественномЧисле = ПолучитьТипВоМножественномЧисле(Тип);
	
КонецПроцедуры
Функция ПолучитьТипВоМножественномЧисле(Тип)
	Если Тип = "FilterCriterion" Тогда
		Возврат "FilterCriteria";
	ИначеЕсли Найти(Тип, "ChartOf") = 1 Тогда
		Возврат СтрЗаменить(Тип, "ChartOf", "ChartsOf");
	ИначеЕсли Тип = "BusinessProcess" Тогда
		Возврат "BusinessProcesses";
	Иначе
		Возврат Тип + "s";
	КонецЕсли;
КонецФункции


Функция ОбъектМД_ПринадлежитКоллекции(Тип_или_ТипВидЧерезТочку, Вид = Неопределено)
	
	Если НЕ Вид = Неопределено Тогда
		Тип = Тип_или_ТипВидЧерезТочку;
	ИначеЕсли СтрЧислоВхождений(Тип_или_ТипВидЧерезТочку, ".") <> 1 Тогда
		Возврат Ложь;
	Иначе
		ТипВид = СтрЗаменить(Тип_или_ТипВидЧерезТочку, ".", Символы.ПС);
		Тип = СтрПолучитьСтроку(ТипВид, 1);
		Вид = СтрПолучитьСтроку(ТипВид, 2);
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Тип", Тип);
	Отбор.Вставить("Вид", Вид);
	Возврат КоллекцияОбъектовМД.НайтиСтроки(Отбор).Количество() > 0;
КонецФункции

Функция ОбъектМД_НайтиВсеФайлыXML(СтрокаОбъекта, КаталогПоиска)
	
	ВсеНайденныеФайлы = ОбъектМД_НайтиФайлыОписанияУправляемыхФормОбъекта(СтрокаОбъекта, КаталогПоиска);
	
	НайденныеФайлы = ОбъектМД_НайтиФайлОписанияОбъекта(СтрокаОбъекта, КаталогПоиска);
	Для Каждого Файл Из НайденныеФайлы Цикл
		ВсеНайденныеФайлы.Добавить(Файл);
	КонецЦикла;
	
	НайденныеФайлы = ОбъектМД_НайтиФайлыОписанияМакетовОбъекта(СтрокаОбъекта, КаталогПоиска);
	Для Каждого Файл Из НайденныеФайлы Цикл
		ВсеНайденныеФайлы.Добавить(Файл);
	КонецЦикла;
	
	МассивСпецифичныхФайлов = Новый Массив;
	МассивСпецифичныхФайлов.Добавить("Predefined");
	МассивСпецифичныхФайлов.Добавить("Rights");
	МассивСпецифичныхФайлов.Добавить("Style");
	Для Каждого ЧастьИмениФайла Из МассивСпецифичныхФайлов Цикл
		НайденныеФайлы = ОбъектМД_НайтиФайлОписанияИзКаталога_Ext(СтрокаОбъекта, КаталогПоиска, ЧастьИмениФайла);
		Для Каждого Файл Из НайденныеФайлы Цикл
			ВсеНайденныеФайлы.Добавить(Файл);
		КонецЦикла;
	КонецЦикла;
	
	Возврат ВсеНайденныеФайлы;
	
КонецФункции
Функция ОбъектМД_НайтиФайлОписанияОбъекта(СтрокаОбъекта, КаталогПоиска)
	
	Если мЭтоИерархическаяВыгрузка Тогда
		ИмяФайла = СтрокаОбъекта.ТипВоМножественномЧисле + ПолучитьРазделительПути() + СтрокаОбъекта.Вид;
	Иначе
		ИмяФайла = СтрокаОбъекта.Тип + "." + СтрокаОбъекта.Вид;
	КонецЕсли;
	
	ИмяФайла = КаталогПоиска + ИмяФайла + ".xml";
	
	Возврат НайтиФайлы(ИмяФайла);
	
КонецФункции
Функция ОбъектМД_НайтиФайлыОписанияУправляемыхФормОбъекта(СтрокаОбъекта, КаталогПоиска)
	Если мЭтоИерархическаяВыгрузка Тогда
		КаталогОбъекта = КаталогПоиска 
							+ СтрокаОбъекта.ТипВоМножественномЧисле + ПолучитьРазделительПути() 
							+ СтрокаОбъекта.Вид + ПолучитьРазделительПути()
							+ "Forms"+ПолучитьРазделительПути();
							
		Маска = "Form.xml";
	Иначе
		КаталогОбъекта = КаталогПоиска;
		Маска = СтрокаОбъекта.Тип + "." + СтрокаОбъекта.Вид + ".Form.*.Form.xml" ;
	КонецЕсли;
	
	Возврат НайтиФайлы(КаталогОбъекта, Маска, Истина);
КонецФункции
Функция ОбъектМД_НайтиФайлыОписанияОбычныхФормОбъекта(СтрокаОбъекта, КаталогПоиска)
	Если мЭтоИерархическаяВыгрузка Тогда
		КаталогОбъекта = КаталогПоиска 
							+ СтрокаОбъекта.ТипВоМножественномЧисле + ПолучитьРазделительПути() 
							+ СтрокаОбъекта.Вид + ПолучитьРазделительПути()
							+ "Forms"+ПолучитьРазделительПути();
							
		Маска = "Form.bin";
	Иначе
		КаталогОбъекта = КаталогПоиска;
		Маска = СтрокаОбъекта.Тип + "." + СтрокаОбъекта.Вид + ".Form.*.Form" ;
	КонецЕсли;
	
	Возврат НайтиФайлы(КаталогОбъекта, Маска, Истина);
КонецФункции
Функция ОбъектМД_НайтиФайлыОписанияМакетовОбъекта(СтрокаОбъекта, КаталогПоиска)
	Если мЭтоИерархическаяВыгрузка Тогда
		КаталогОбъекта = КаталогПоиска 
							+ СтрокаОбъекта.ТипВоМножественномЧисле + ПолучитьРазделительПути() 
							+ СтрокаОбъекта.Вид + ПолучитьРазделительПути()
							+ "Templates"+ПолучитьРазделительПути();
							
		Маска = "Template.xml";
	Иначе
		КаталогОбъекта = КаталогПоиска;
		Маска = СтрокаОбъекта.Тип + "." + СтрокаОбъекта.Вид + ".Template.*.Template.xml" ;
	КонецЕсли;
	
	Возврат НайтиФайлы(КаталогОбъекта, Маска, Истина);
КонецФункции
Функция ОбъектМД_НайтиФайлОписанияИзКаталога_Ext(СтрокаОбъекта, КаталогПоиска, ПоследняяЧастьИмениФайла)
	Если мЭтоИерархическаяВыгрузка Тогда
		КаталогОбъекта = КаталогПоиска 
							+ СтрокаОбъекта.ТипВоМножественномЧисле + ПолучитьРазделительПути() 
							+ СтрокаОбъекта.Вид + ПолучитьРазделительПути()
							+ "Ext"+ПолучитьРазделительПути();
							
		Маска = ПоследняяЧастьИмениФайла+".xml";
	Иначе
		КаталогОбъекта = КаталогПоиска;
		Маска = СтрокаОбъекта.Тип + "." + СтрокаОбъекта.Вид + "."+ПоследняяЧастьИмениФайла+".xml" ;
	КонецЕсли;
	
	Возврат НайтиФайлы(КаталогОбъекта, Маска, Истина);
КонецФункции


Функция ОбъектМД_СкопироватьФайлы(СтрокаОбъекта)
	
	Если мЭтоИерархическаяВыгрузка Тогда
		Возврат ОбъектМД_СкопироватьФайлы_СИерархией(СтрокаОбъекта);
	Иначе
		Возврат ОбъектМД_СкопироватьФайлы_Линейно(СтрокаОбъекта);
	КонецЕсли;
	
КонецФункции
Функция ОбъектМД_СкопироватьФайлы_Линейно(СтрокаОбъекта)
	СкопировалиХотьОдинФайл = Ложь;
	
	Маска = ?(СтрокаОбъекта.ЭтоЗаглушка, "*.xml", ".*");
	
	НайденныеФайлы = НайтиФайлы(КаталогИсходныхФайлов, СтрокаОбъекта.Тип + "." + СтрокаОбъекта.Вид + Маска);
	Для каждого Файл из НайденныеФайлы Цикл
		Если НЕ СтрокаОбъекта.ЭтоЗаглушка Тогда
		ИначеЕсли Найти(Файл.Имя, ".Style.xml") Тогда
			Продолжить;
		ИначеЕсли Найти(Файл.Имя, ".Help.xml") Тогда
			Продолжить;
		ИначеЕсли Найти(Файл.Имя, ".Form.xml") Тогда
			Продолжить;
		ИначеЕсли Найти(Файл.Имя, ".Picture.xml") Тогда
			Продолжить;
		ИначеЕсли Найти(Файл.Имя, ".Template.") Тогда
			Продолжить;
		КонецЕсли;
		
		СкопироватьФайлВКаталогСборки(Файл.ПолноеИмя);
		СкопировалиХотьОдинФайл = Истина;
	КонецЦикла;
	
	Возврат СкопировалиХотьОдинФайл;
	
КонецФункции
Функция ОбъектМД_СкопироватьФайлы_СИерархией(СтрокаОбъекта)
	
	ОбъектМД_СкопироватьФайлы_СИерархией_СоздатьВложенныеКаталоги(СтрокаОбъекта);
	
	Возврат ОбъектМД_СкопироватьФайлы_СИерархией_СкопироватьФайлы(СтрокаОбъекта);
	
КонецФункции
Процедура ОбъектМД_СкопироватьФайлы_СИерархией_СоздатьВложенныеКаталоги(СтрокаОбъекта)
	
	КаталогОбъекта = КаталогИсходныхФайлов + СтрокаОбъекта.ТипВоМножественномЧисле + ПолучитьРазделительПути() + СтрокаОбъекта.Вид;
	ИскатьВПодкаталогах = НЕ СтрокаОбъекта.ЭтоЗаглушка;
	НайденныеФайлы = НайтиФайлы(КаталогОбъекта,  "*.", ИскатьВПодкаталогах);
	Для Каждого Файл Из НайденныеФайлы Цикл
		ИмяФайлаПриемника = КаталогСборки + Сред(Файл.ПолноеИмя, СтрДлина(КаталогИсходныхФайлов)+1);
		СоздатьКаталог(ИмяФайлаПриемника);
	КонецЦикла;
	
КонецПроцедуры
Функция ОбъектМД_СкопироватьФайлы_СИерархией_СкопироватьФайлы(СтрокаОбъекта)
	
	КаталогТипа = КаталогИсходныхФайлов + СтрокаОбъекта.ТипВоМножественномЧисле + ПолучитьРазделительПути();
	
	
	ИскатьВПодкаталогах = НЕ СтрокаОбъекта.ЭтоЗаглушка;
	НайденныеФайлы = НайтиФайлы(КаталогТипа + СтрокаОбъекта.Вид, "*", ИскатьВПодкаталогах);
	
	ГлавныйФайлОбъекта = Новый Файл(КаталогТипа + СтрокаОбъекта.Вид + ".xml");
	Если НЕ ГлавныйФайлОбъекта.Существует() Тогда
		Возврат Ложь;
	КонецЕсли;
	НайденныеФайлы.Добавить(ГлавныйФайлОбъекта);
	
	МассивМассивовФайлов = Новый Массив;
	МассивМассивовФайлов.Добавить(НайденныеФайлы);
	
	Если СтрокаОбъекта.ЭтоЗаглушка Тогда
		НайденныеФайлы = НайтиФайлы(КаталогТипа + СтрокаОбъекта.Вид + ПолучитьРазделительПути() +"Forms", "*" , ИскатьВПодкаталогах);
		МассивМассивовФайлов.Добавить(НайденныеФайлы);
		
		НайденныеФайлы = НайтиФайлы(КаталогТипа + СтрокаОбъекта.Вид + ПолучитьРазделительПути() +"Templates", "*" , ИскатьВПодкаталогах);
		МассивМассивовФайлов.Добавить(НайденныеФайлы);
		
		НайденныеФайлы = НайтиФайлы(КаталогТипа + СтрокаОбъекта.Вид + ПолучитьРазделительПути() +"Ext", "Predefined.xml" , ИскатьВПодкаталогах);
		МассивМассивовФайлов.Добавить(НайденныеФайлы);
	КонецЕсли;
	
	
	Для Каждого НайденныеФайлы Из МассивМассивовФайлов Цикл
		Для Каждого Файл Из НайденныеФайлы Цикл
			Если Файл.ЭтоКаталог() Тогда
				Продолжить;
			КонецЕсли;
			СкопироватьФайлВКаталогСборки(Файл.ПолноеИмя);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции


Процедура КоллекцияОбъектовМД_ЗаполнитьИзМассива(МассивОбъектов, ЭтоЗаглушки)
	
	Для каждого Тип_Вид_Элемента из МассивОбъектов Цикл
		Тип_Вид_Элемента = СтрЗаменить(Тип_Вид_Элемента, ".", Символы.ПС);
		
		Тип = СтрПолучитьСтроку(Тип_Вид_Элемента, 1);
		Вид = СтрПолучитьСтроку(Тип_Вид_Элемента, 2);
		
		Если ОбъектМД_ПринадлежитКоллекции(Тип, Вид) Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектМД_ДобавитьВКоллекцию(Тип, Вид, Истина);
		
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти

#Область _ // Работа с файлами

Функция ПутьККопииФайла(ПутьКФайлу)
	
	Файл = Новый Файл(ПутьКФайлу);
	НовыйПутьКФайлу = КаталогВременныхФайлов() + Файл.Имя;
	
	КопироватьФайл(ПутьКФайлу, НовыйПутьКФайлу);
	
	Возврат НовыйПутьКФайлу;
	
КонецФункции
Функция ПутьККаталогуСоСлешем(ПутьККаталогуСоСлешемИлиБез)
	
	Файл = Новый Файл(ПутьККаталогуСоСлешемИлиБез);
	Возврат Файл.ПолноеИмя + ПолучитьРазделительПути();
	
КонецФункции
Функция ПолучитьРасширениеФайла(ПутьКФайлу)
	Файл = Новый Файл(ПутьКФайлу);
	Возврат Файл.Расширение;
КонецФункции
Процедура СкопироватьФайлВКаталогСборки(ИмяФайлаИсточника)
	
	ИмяФайлаПриемника = КаталогСборки + Сред(ИмяФайлаИсточника, СтрДлина(КаталогИсходныхФайлов)+1);
	
	КопироватьФайл(ИмяФайлаИсточника, ИмяФайлаПриемника);
	
КонецПроцедуры


#КонецОбласти

#Область _ // Работа с DOM

Функция ПрочитатьDOMИзСтроки(Строка)
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(Строка);
	ПостроительDOM = Новый ПостроительDOM;
	
	Возврат ПостроительDOM.Прочитать(ЧтениеXML);
КонецФункции
Функция ПрочитатьDOMИзФайла(ПутьКФайлу) 
	
	ЧтениеXML=Новый ЧтениеXML(); 
	ПараметрыЧтения = Новый ПараметрыЧтенияXML(,,,ТипПроверкиXML.НетПроверки);
	ЧтениеXML.ОткрытьФайл(ПутьКФайлу, ПараметрыЧтения);
	ПостроительDOM = Новый ПостроительDOM;
	ОбъектDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	ЧтениеXML.Закрыть();
	
	Возврат ОбъектDOM;
	
КонецФункции
Процедура ЗаписатьDOMОбъектВФайл(DOMОбъект, ПутьКФайлу)
	
	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.ОткрытьФайл(ПутьКФайлу);
	ЗаписьDOM = Новый ЗаписьDOM();
	ЗаписьDOM.Записать(DOMОбъект, ЗаписьXML);
	ЗаписьXML.Закрыть();	
	
КонецПроцедуры
Процедура ОчиститьДочерниеУзлыDOMОбъекта(DOMОбъект, ИмяРодительскогоУзла)
	
	НайденныйУзел = DOMОбъект.ПолучитьЭлементыПоИмени(ИмяРодительскогоУзла)[0];
	Пока НайденныйУзел.ЕстьДочерниеУзлы() Цикл
		НайденныйУзел.УдалитьДочерний(НайденныйУзел.ПервыйДочерний);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
