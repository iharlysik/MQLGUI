//+------------------------------------------------------------------+
//|                                                      Defines.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//--- Имя класса
#define CLASS_NAME ::StringSubstr(__FUNCTION__,0,::StringFind(__FUNCTION__,"::"))
//--- Имя программы
#define PROGRAM_NAME ::MQLInfoString(MQL_PROGRAM_NAME)
//--- Тип программы
#define PROGRAM_TYPE (ENUM_PROGRAM_TYPE)::MQLInfoInteger(MQL_PROGRAM_TYPE)
//--- Предотвращение выхода из диапазона
#define PREVENTING_OUT_OF_RANGE __FUNCTION__," > Предотвращение выхода за пределы массива."

//--- Шрифт
#define FONT      ("Calibri")
#define FONT_SIZE (8)

//--- Шаг таймера (миллисекунды)
#define TIMER_STEP_MSC (16)
//+------------------------------------------------------------------+
