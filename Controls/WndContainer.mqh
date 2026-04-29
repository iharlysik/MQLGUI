//+------------------------------------------------------------------+
//|                                                 WndContainer.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Window.mqh"
//+------------------------------------------------------------------+
//| Класс для хранения всех объектов интерфейса                      |
//+------------------------------------------------------------------+
class CWndContainer
  {
protected:
   //--- Массив окон
   CWindow          *m_windows[];
   //--- Структура массивов элементов
   struct WindowElements
     {
      //--- Общий массив всех объектов
      CChartObject     *m_objects[];
      //--- Общий массив всех элементов
      CElement         *m_elements[];
     };
   //--- Массив массивов элементов для каждого окна
   WindowElements    m_wnd[];
   //---
private:
   //--- Счётчик элементов
   int               m_counter_element_id;
   //---
protected:
                     CWndContainer();
                    ~CWndContainer();
   //---
public:
   //--- Количество окон в интерфейсе
   int               WindowsTotal(void) { return(::ArraySize(m_windows)); }
   //--- Количество объектов всех элементов
   int               ObjectsElementsTotal(const int window_index);
   //--- Количество элементов
   int               ElementsTotal(const int window_index);
   //---
protected:
   //--- Добавляет указатель окна в базу элементов интерфейса
   void              AddWindow(CWindow &object);
   //--- Добавляет указатели объектов элемента в общий массив
   template<typename T>
   void              AddToObjectsArray(const int window_index,T &object);
   //--- Добавляет указатель объекта в массив
   void              AddToArray(const int window_index,CChartObject &object);
   //---
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CWndContainer::CWndContainer(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CWndContainer::~CWndContainer(void)
  {
  }
//+------------------------------------------------------------------+
//| Возвращает кол-во объектов по указанному индексу окна            |
//+------------------------------------------------------------------+
int CWndContainer::ObjectsElementsTotal(const int window_index)
  {
   if(window_index>=::ArraySize(m_wnd))
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//---
   return(::ArraySize(m_wnd[window_index].m_objects));
  }
//+------------------------------------------------------------------+
//| Возвращает кол-во элементов по указанному индексу окна           |
//+------------------------------------------------------------------+
int CWndContainer::ElementsTotal(const int window_index)
  {
   if(window_index>=::ArraySize(m_wnd))
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//---
   return(::ArraySize(m_wnd[window_index].m_elements));
  }
//+------------------------------------------------------------------+
//| Добавляет указатель окна в базу элементов интерфейса             |
//+------------------------------------------------------------------+
void CWndContainer::AddWindow(CWindow &object)
  {
   int windows_total=::ArraySize(m_windows);
//--- Если окон нет, обнулим счётчик элементов
   if(windows_total<=0)
      m_counter_element_id=0;
//--- Добавим указатель в массив окон
   ::ArrayResize(m_wnd,windows_total+1);
   ::ArrayResize(m_windows,windows_total+1);
   m_windows[windows_total]=::GetPointer(object);
//--- Добавим указатель в общий массив элементов
   int elements_total=::ArraySize(m_wnd[windows_total].m_elements);
   ::ArrayResize(m_wnd[windows_total].m_elements,elements_total+1);
   m_wnd[windows_total].m_elements[elements_total]=::GetPointer(object);
//--- Добавим объекты элемента в общий массив объектов
   AddToObjectsArray(windows_total,object);
//--- Установим идентификатор и запомним id последнего элемента
   m_windows[windows_total].Id(m_counter_element_id);
   m_windows[windows_total].LastId(m_counter_element_id);
//--- Увеличим счётчик идентификаторов элементов
   m_counter_element_id++;
  }
//+------------------------------------------------------------------+
//| Добавляет указатели объектов элемента в общий массив             |
//+------------------------------------------------------------------+
template<typename T>
void CWndContainer::AddToObjectsArray(const int window_index,T &object)
  {
   int total=object.ObjectsElementTotal();
   for(int i=0; i<total; i++)
      AddToArray(window_index,object.Object(i));
  }
//+------------------------------------------------------------------+
//| Добавляет указатель объекта в массив                             |
//+------------------------------------------------------------------+
void CWndContainer::AddToArray(const int window_index,CChartObject &object)
  {
   int size=::ArraySize(m_wnd[window_index].m_objects);
   ::ArrayResize(m_wnd[window_index].m_objects,size+1);
   m_wnd[window_index].m_objects[size]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
