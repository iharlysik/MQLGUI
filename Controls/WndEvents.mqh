//+------------------------------------------------------------------+
//|                                                    WndEvents.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Defines.mqh"
#include "WndContainer.mqh"
#include <Charts\Chart.mqh>
//+------------------------------------------------------------------+
//| Класс для обработки событий                                      |
//+------------------------------------------------------------------+
class CWndEvents : public CWndContainer
  {
protected:
   CChart            m_chart;
   //--- Идентификатор и номер окна графика
   long              m_chart_id;
   int               m_subwin;
   //--- Имя программы
   string            m_program_name;
   //--- Короткое имя индикатора
   string            m_indicator_shortname;
   //---
private:
   //--- Параметры событий
   int               m_id;
   long              m_lparam;
   double            m_dparam;
   string            m_sparam;
   //---
protected:
                     CWndEvents(void);
                    ~CWndEvents(void);
   //--- Виртуальный обработчик события графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam) {}
   //--- Таймер
   void              OnTimerEvent(void);
   //---
public:
   //--- Обработчики событий графика
   void              ChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
private:
   void              ChartEventCustom(void);
   void              ChartEventClick(void);
   void              ChartEventMouseMove(void);
   void              ChartEventObjectClick(void);
   void              ChartEventEndEdit(void);
   void              ChartEventChartChange(void);
   //--- Проверка событий в элементах управления
   void              CheckElementsEvents(void);
   //--- Определение номера подокна
   void              DetermineSubwindow(void);
   //--- Проверка событий элементов управления
   void              CheckSubwindowNumber(void);
   //--- Инициализация параметров событий
   void              InitChartEventsParams(const int id,const long lparam,const double dparam,const string sparam);
   //--- Перемещение окна
   void              MovingWindow(void);
   //--- Проверка событий всех элементов по таймеру
   void              CheckElementsEventsTimer(void);
   //---
protected:
   //--- Удаление интерфейса
   void              Destroy(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CWndEvents::CWndEvents(void) : m_chart_id(0),
                               m_subwin(0),
                               m_indicator_shortname("")
  {
//--- Включим таймер
   if(!::MQLInfoInteger(MQL_TESTER))
      ::EventSetMillisecondTimer(TIMER_STEP_MSC);
//--- Получим ID текущего графика
   m_chart.Attach();
//--- Включим слежение за событиями мыши
   m_chart.EventMouseMove(true);
//--- Определение номера подокна
   DetermineSubwindow();
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CWndEvents::~CWndEvents(void)
  {
//--- Удалить таймер
   ::EventKillTimer();
//--- Включим управление
   m_chart.MouseScroll(true);
   m_chart.SetInteger(CHART_DRAG_TRADE_LEVELS,true);
//--- Отключим слежение за событиями мыши
   m_chart.EventMouseMove(false);
//--- Отсоединиться от графика
   m_chart.Detach();
//--- Стереть коммент   
   ::Comment("");
  }
//+------------------------------------------------------------------+
//| Инициализация событийных переменных                              |
//+------------------------------------------------------------------+
void CWndEvents::InitChartEventsParams(const int id,const long lparam,const double dparam,const string sparam)
  {
   m_id     =id;
   m_lparam =lparam;
   m_dparam =dparam;
   m_sparam =sparam;
  }
//+------------------------------------------------------------------+
//| Обработка событий программы                                      |
//+------------------------------------------------------------------+
void CWndEvents::ChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Если массив пуст, выйдем
   if(CWndContainer::WindowsTotal()<1)
      return;
//--- Инициализация полей параметров событий
   InitChartEventsParams(id,lparam,dparam,sparam);
//--- Проверка событий элементов интерфейса
   CheckElementsEvents();
//--- Событие перемещения мыши
   ChartEventMouseMove();
//--- Событие изменения свойств графика
   ChartEventChartChange();
  }
//+------------------------------------------------------------------+
//| Проверка событий элементов управления                            |
//+------------------------------------------------------------------+
void CWndEvents::CheckElementsEvents(void)
  {
   int elements_total=CWndContainer::ElementsTotal(0);
   for(int e=0; e<elements_total; e++)
      m_wnd[0].m_elements[e].OnEvent(m_id,m_lparam,m_dparam,m_sparam);
//--- Направление события в файл приложения
   OnEvent(m_id,m_lparam,m_dparam,m_sparam);
  }
//+------------------------------------------------------------------+
//| Событие CHARTEVENT_CUSTOM                                        |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventCustom(void)
  {
  }
//+------------------------------------------------------------------+
//| Событие CHARTEVENT CLICK                                         |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventClick(void)
  {
  }
//+------------------------------------------------------------------+
//| Событие CHARTEVENT MOUSE MOVE                                    |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventMouseMove(void)
  {
//--- Выйти, если это не событие перемещения курсора
   if(m_id!=CHARTEVENT_MOUSE_MOVE)
      return;
//--- Перемещение окна
   MovingWindow();
//--- Перерисуем график
   m_chart.Redraw();
  }
//+------------------------------------------------------------------+
//| Событие CHARTEVENT OBJECT CLICK                                  |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventObjectClick(void)
  {
  }
//+------------------------------------------------------------------+
//| Событие CHARTEVENT OBJECT ENDEDIT                                |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventEndEdit(void)
  {
  }
//+------------------------------------------------------------------+
//| Событие CHARTEVENT CHART CHANGE                                  |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventChartChange(void)
  {
//--- Событие изменения свойств графика
   if(m_id!=CHARTEVENT_CHART_CHANGE)
      return;
//--- Проверка и обновление номера окна программы
   CheckSubwindowNumber();
//--- Перемещение окна
   MovingWindow();
//--- Перерисуем график
   m_chart.Redraw();
  }
//+------------------------------------------------------------------+
//| Таймер                                                           |
//+------------------------------------------------------------------+
void CWndEvents::OnTimerEvent(void)
  {
//--- Если массив пуст, выйдем  
   if(CWndContainer::WindowsTotal()<1)
      return;
//--- Проверка событий всех элементов по таймеру
   CheckElementsEventsTimer();
//--- Перерисуем график
   m_chart.Redraw();
  }
//+------------------------------------------------------------------+
//| Перемещение окна                                                 |
//+------------------------------------------------------------------+
void CWndEvents::MovingWindow(void)
  {
//--- Перемещение окна
   int x=m_windows[0].X();
   int y=m_windows[0].Y();
   m_windows[0].Moving(x,y);
//--- Перемещение элементов управления
   int elements_total=CWndContainer::ElementsTotal(0);
   for(int e=0; e<elements_total; e++)
      m_wnd[0].m_elements[e].Moving(x,y);
  }
//+------------------------------------------------------------------+
//| Проверка событий всех элементов по таймеру                       |
//+------------------------------------------------------------------+
void CWndEvents::CheckElementsEventsTimer(void)
  {
   int elements_total=CWndContainer::ElementsTotal(0);
   for(int e=0; e<elements_total; e++)
      m_wnd[0].m_elements[e].OnEventTimer();
  }
//+------------------------------------------------------------------+
//| Определение номера подокна                                       |
//+------------------------------------------------------------------+
void CWndEvents::DetermineSubwindow(void)
  {
//--- Если тип программы не индикатор, выйдем
   if(PROGRAM_TYPE!=PROGRAM_INDICATOR)
      return;
//--- Сброс последней ошибки
   ::ResetLastError();
//--- Определение номера окна индикатора
   m_subwin=::ChartWindowFind();
//--- Если не получилось определить номер, выйдем
   if(m_subwin<0)
     {
      ::Print(__FUNCTION__," > Ошибка при определении номера подокна: ",::GetLastError());
      return;
     }
//--- Если это не главное окно графика
   if(m_subwin>0)
     {
      //--- Получим общее количество индикаторов в указанном подокне
      int total=::ChartIndicatorsTotal(m_chart_id,m_subwin);
      //--- Получим короткое имя последнего индикатора в списке
      string indicator_name=::ChartIndicatorName(m_chart_id,m_subwin,total-1);
      //--- Если в подокне уже есть индикатор, то удалить программу с графика
      if(total!=1)
        {
         ::Print(__FUNCTION__," > В этом подокне уже есть индикатор.");
         ::ChartIndicatorDelete(m_chart_id,m_subwin,indicator_name);
         return;
        }
     }
  }
//+------------------------------------------------------------------+
//| Проверка и обновление номера окна программы                      |
//+------------------------------------------------------------------+
void CWndEvents::CheckSubwindowNumber(void)
  {
//--- Если программа в подокне и номера не совпадают
   if(m_subwin!=0 && m_subwin!=::ChartWindowFind())
     {
      //--- Определить номер подокна
      DetermineSubwindow();
      //--- Сохранить во всех элементах
      int windows_total=CWndContainer::WindowsTotal();
      for(int w=0; w<windows_total; w++)
        {
         int elements_total=CWndContainer::ElementsTotal(w);
         for(int e=0; e<elements_total; e++)
            m_wnd[w].m_elements[e].SubwindowNumber(m_subwin);
        }
     }
  }
//+------------------------------------------------------------------+
//| Удаление всех объектов                                           |
//+------------------------------------------------------------------+
void CWndEvents::Destroy(void)
  {
   int window_total=CWndContainer::WindowsTotal();
   for(int w=0; w<window_total; w++)
     {
      int elements_total=CWndContainer::ElementsTotal(w);
      for(int e=0; e<elements_total; e++)
        {
         //--- Если указатель невалидный, перейти к следующему
         if(::CheckPointer(m_wnd[w].m_elements[e])==POINTER_INVALID)
            continue;
         //--- Удалить объекты элемента
         m_wnd[w].m_elements[e].Delete();
        }
      //--- Освободить массивы элементов
      ::ArrayFree(m_wnd[w].m_objects);
      ::ArrayFree(m_wnd[w].m_elements);
     }
//--- Освободить массивы форм
   ::ArrayFree(m_wnd);
   ::ArrayFree(m_windows);
  }
//+------------------------------------------------------------------+
