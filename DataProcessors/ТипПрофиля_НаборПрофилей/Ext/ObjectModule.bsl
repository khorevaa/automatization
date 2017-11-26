﻿#Область ПрограммныйИнтерфейс

Процедура ВыполнитьСценарий() Экспорт
	
	ВыполнитьСценарииИзНабораПрофилей();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьСценарииИзНабораПрофилей()
	
	БылиОшибки = Ложь;
	Для каждого Строка из НаборПрофилей Цикл
		
		Если БылиОшибки=Истина И Строка.НеПропускатьПриОшибке=Ложь Тогда
			Продолжить;
		КонецЕсли;
		
		Состояние(Строка.Профиль);
		
		ПрофильОбъект = Строка.Профиль.ПолучитьОбъект();
		
		Попытка
			Состояние(ПрофильОбъект.Наименование);
			ПрофильОбъект.ВыполнитьТекущийСценарий();
		Исключение
			ТекстИсключения = ОписаниеОшибки();
			БылиОшибки = Истина;
			
			Логирование.ЗаписатьЛог(ТекстИсключения);
			Сообщить(ТекстИсключения, СтатусСообщения.ОченьВажное);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти



