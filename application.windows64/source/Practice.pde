//класс пользователя
class member {
  String login;//логин
  String pass;//пароль
  int AccessLevel;//уровень доступа
  member(int AL, String l, String p)//конструктор
  {
    AccessLevel=AL;
    login = l;
    pass = p;
  }
}
//класс заметки
class note {
  String name;//название заметки
  String text;//текст заметки
  String Owner;//создатель заметки
  ArrayList<String> readers;//ТД список тех пользователей, которые читали заметку
  int AccessLevel;//уровень доступа
  note(String N, String O, int AL)//конструктор
  {
    readers = new ArrayList<String>();
    text = "";
    name=N;
    Owner=O;
    AccessLevel=AL;
  }
}

ArrayList<member> members = new ArrayList<member>();//список пользователей
ArrayList<note> notes = new ArrayList<note>();//список заметок
int page, fromi;//текущая страница, отступ для отображения списка заметок
member AthorizedMember;//авторизированный пользователь
String[] container = {"", "", "", "", ""};//контейнер для полей ввода-вывода
int currentCont, currentNote=-1;//текущий контейнер для ввода, выбранная заметка, счётчик переноса строки

//инициалтзация (старт программы)
void setup()
{
  //шрифт
  PFont myFont;
  myFont = createFont("Consolas", 32);
  textFont(myFont);
  textSize(10);

  //начальные значения
  page=0;
  currentCont=0;
  fromi=0;
  //пререгистрированные пользователи
  members.add(new member(4, "Administrator", "fluttersD@T@1337"));
  members.add(new member(2, "admin", "admin"));
  members.add(new member(0, "qwer", "qwer"));
  //тестовая заметка (есть с самого начала)
  notes.add(new note("Welcome!", "Sys", 0));
  notes.get(0).text = "hello world!\nhello hello universe!!";
  //задание разрешения окна
  size(800, 600);
}

//метод перерисовки (60 раз в секунду)
void draw()
{
  //проверка текущей страницы
  if (page==0)//страница регистрации
  {
    //установка цвета фона
    background(51);
    fill(20);//установка цвета заливки
    rect(width/2-105, height/2-20, 210, 120);//рисуем прямоугольник
    rect(width/2-105, height/2+110, 140, 15);
    rect(width/2+45, height/2+110, 60, 15);
    fill(255);//установка цвета заливки
    //пишем текст
    text("Registration", width/2-100, height/2);
    text("Login: "+container[0], width/2-100, height/2+30);
    text("Password: "+container[1], width/2-100, height/2+60);
    text("Access key: "+container[2], width/2-100, height/2+90);
    text("next", width/2+50, height/2+120);
    text("go to enter page", width/2-100, height/2+120);
  } else if (page==1)//страница входа
  {
    //установка цвета фона
    background(51);
    fill(20);//установка цвета заливки
    rect(width/2-105, height/2-20, 210, 120);//рисуем прямоугольник
    rect(width/2-105, height/2+110, 140, 15);
    rect(width/2+45, height/2+110, 60, 15);
    fill(255);//установка цвета заливки
    //пишем текст
    text("Enter", width/2-100, height/2);
    text("Login: "+container[0], width/2-100, height/2+30);
    text("Password: "+container[1], width/2-100, height/2+60);
    text("next", width/2+50, height/2+120);
    text("go to registration page", width/2-100, height/2+120);
  } else if (page==2)//страница заметок
  {
    //установка цвета фона
    background(42);
    fill(20);//установка цвета заливки

    //рисуем прямоугольники
    rect(width/2-100, 10, width/2+90, height-20);
    rect(10, 10, width/3, height/8-30);
    rect(10, height/8-10, width/3, height/8+30);
    rect(10, height/4 +40, width/3, 400);

    //рисуем список заметок
    for (int i=0; i<8; i++)
    {
      //проверяем на переполнение
      if (i+fromi<notes.size())
      {
        //установка цвета заливки
        fill(120);
        stroke(0);//установка цвета обводки
        if (currentNote==i+fromi)//если заметка, которую мы сейчас рисуем, я вляется выбранной
          stroke(0, 255, 0);//установка цвета обводки
        rect(width/2-90, 20+73*(i), width/2+70, 50);//рисуем прямоугольник
        fill(255);//установка цвета заливки
        text((i+fromi)+"."+notes.get(i+fromi).name+"\nlevel:"+notes.get(i+fromi).AccessLevel+"\ncreator:"+notes.get(i+fromi).Owner, width/2-80, 20+73*(i)+15);//информация о заметке
      }
    }
    stroke(0);//установка цвета обводки
    fill(255);//установка цвета заливки
    //пишем инфо о пользователе
    text("user: "+AthorizedMember.login+ "\nlevel: "+AthorizedMember.AccessLevel, 20, 30);
    //кнопка для выхода
    text("logout", 200, 40);
    //поля для воода инфо о заметке
    text("name of note: "+container[0], 20, 80);
    text("level: "+container[1], 20, 110);

    //поле для отображения и редактирования текста заметки
    text(container[3], 20, 210);

    //функциональные кнопки
    text("create", 20, 140);
    text("delete", 80, 140);
    text("view", 140, 140);
    text("write", 200, 140);
  }
}
//метод вызываемый при клике мышкой
void mouseClicked()
{
  //проверка страницы
  if (page==0)//страница регистрации
  {
    //установка текущего контейнера для записи
    if (mouseY<height/2+40 && mouseY>height/2+10)//логин
      currentCont=0;
    if (mouseY<height/2+70 && mouseY>height/2+40)//пароль
      currentCont=1;
    if (mouseY<height/2+100 && mouseY>height/2+70)//ключ досткпа
      currentCont=2;

    if (mouseY<height/2+130 && mouseY>height/2+100 && mouseX>width/2+40)//кнопка next
    {
      if (verifyReg(container[0], container[1], container[2]))//проверка действительности регистрации
      {
        for (int i=0; i<container.length; i++)//очищаем все контейнеры
          container[i]="";
        page=1;//установка текущей страницы
      } else
      {
        for (int i=0; i<container.length; i++)//выводим сообщение об ошибке
          container[i]="ERROR";
      }
    }
    if (mouseY<height/2+130 && mouseY>height/2+100 && mouseX<width/2+40)//кнопка go to enter page
    {
      for (int i=0; i<container.length; i++)//очищаем все контейнеры
        container[i]="";
      page=1;//установка текущей страницы
    }
  } else if (page==1)//страница входа
  {
    //установка текущего контейнера для записи
    if (mouseY<height/2+40 && mouseY>height/2+10)//логин
      currentCont=0;
    if (mouseY<height/2+70 && mouseY>height/2+40)//пароль
      currentCont=1;


    if (mouseY<height/2+130 && mouseY>height/2+100 && mouseX>width/2+40)//кнопка next
    {
      if (verifyLogin(container[0], container[1]))// проверка логина/пароля
      {
        for (int i=0; i<container.length; i++)//очищаем все контейнеры
          container[i]="";
        page=2;//установка текущей страницы
      } else
      {
        for (int i=0; i<container.length; i++)//выводим сообщение об ошибке
          container[i]="ERROR";
      }
    }
    if (mouseY<height/2+130 && mouseY>height/2+100 && mouseX<width/2+40)//кнопка go to registration page
    {
      for (int i=0; i<container.length; i++)//очищаем все контейнеры
        container[i]="";
      page=0;//установка текущей страницы
    }
  } else if (page ==2)//страница системы с заметками
  {
    //установка текущего контейнера для записи
    if (mouseY<100 && mouseY>70 && mouseX< width/2-200)//name of note
      currentCont=0;
    if (mouseY<130 && mouseY>100 && mouseX< width/2-200)//level
      currentCont=1;
    if (mouseY<height/4 +440 && mouseY> height/4 +40 && mouseX< width/2-200)//большое текстовое поле
      currentCont=3;


    if (mouseY<160 && mouseY>130 && mouseX< 70)//кнопка create
      createNote();
    if (mouseY<160 && mouseY>130 && mouseX>70 && mouseX< 130)//кнопка delete
      deleteNote();
    if (mouseY<160 && mouseY>130 && mouseX>130 && mouseX< 190)//кнопка view
      viewNote();
    if (mouseY<160 && mouseY>130 && mouseX>190 && mouseX< 250)//кнопка write
      writeNote();

    if (mouseY<60 && mouseY>30 && mouseX>190 && mouseX< 250)//кнопка logout
      logout();



    if (mouseX >width/2-150)// поле с заметками
    {
      for (int i=0; i<8; i++)//проверка всех заметок на экране
      {
        if (i+fromi<notes.size())//проверка на переполнение
        {
          if (mouseY>20+73*(i) && mouseY<70+73*(i))//проверка на текущую заметку
            currentNote = i+fromi;//установление текущей заметки
        }
      }
    }
  }
}

void keyPressed()//метод вызываемый при нажатии на клавиатуру
{
  if (key != CODED && key != BACKSPACE)//ввод текста
  {
    if(container[currentCont].length()<25 || currentCont==3) container[currentCont]+=key;
    checkfornewline(currentCont);
  } else if (key == BACKSPACE && container[currentCont].length()>0)//удаление текста
    container[currentCont] = container[currentCont].substring(0, container[currentCont].length() - 1);
}

void checkfornewline(int cont)// проверка для переноса на новую строку
{
  int i, l=container[cont].length();
  for (i=0; i<45; i++)
  {
    if (container[cont].charAt(l-i-1) == '\n')
      break;
    if (l-i-1==0)
    {
      i=i+1;
      break;
    }
  }
  if (i==44)
    container[cont]+='\n';
}

boolean verifyLogin(String l, String p)// метод проверки логина
{
  for (member v : members)//смотрим всех пользователей
  {
    if (v.login.equals(l) && v.pass.equals(p))//если находи совпадение
    {
      AthorizedMember = v;//авторизируем
      return true;//возвращаем успех
    }
  }
  return false;//вернём ложь, если пользоветель не был найден
}
boolean verifyReg(String l, String p, String c)//метод проверки регистрации
{
  for (member v : members)//смотрим всех пользователей
  {
    if (v.login.equals(l))//если есть пользователь с таким же именем
    {
      print("!USER ALREADY EXISTS!");
      return false;
    }
  }
  //установка уровня доступа
  int lv=0;//пременная для временного хранения уровня доступа 
  //в зависимости от ключа доступа выдаём соответствующий уровень доступа
  if (c.equals(""))
  {
  } else if (c.equals("first"))
  {
    lv=1;
  } else if (c.equals("xc356"))
  {
    lv=2;
  } else if (c.equals("H@ck3R"))
  {
    lv=3;
  } 
   else//если ни один из ключей не подошёл
  {
    print("!BAD KEY!");
    return false;
  }


  // проверка длины логина и пароля
  if (l.length()<6 || p.length() < 6)
  {
    print("!UNSUFFICIENT LENGTH!");
    return false;
  }

  //добавляем пользователя в список
  members.add(new member(lv, l, p));
  print("added "+lv+" "+l+" "+p);
  return true;
}

void createNote()//создание заметки
{
  int l = int(container[1]);//берём число из контейнера уровня (если не число, то равно 0)
  if (l<AthorizedMember.AccessLevel|| l>4)//если уровень заметки меньше уровня доступа пользователя, или слишком большой то выход
    return;
  notes.add(new note(container[0], AthorizedMember.login, l));// добавляем заметку в список
}

void deleteNote()//удаление заметки
{
  if (AthorizedMember.login != notes.get(currentNote).Owner)//если заметка нам не принадлежит то выход
    return;
  notes.remove(currentNote);//удаляем текущую заметку
}

void viewNote()//просмотр заметки
{
  if (AthorizedMember.AccessLevel < notes.get(currentNote).AccessLevel)//если уровень нашего доступа меньше уровня заметки то выход
    return;
  container[3]=notes.get(currentNote).text;//установка текста заметки в большое поле
}

void writeNote()//запись заметки
{
  if (currentNote==-1 ||currentNote>= notes.size())//проверка на выходы за границы массива
    return;
  if (AthorizedMember.login != notes.get(currentNote).Owner)//если заметка нам не принадлежит, то выход
    return;
  if (AthorizedMember.AccessLevel > notes.get(currentNote).AccessLevel)// если наш уровень больше уровня заметки, то выход
    return;
  notes.get(currentNote).text=container[3];// то записываем текст из большого поля в заметки
  container[3]+="\n\n\n---[successfull write]---";//выводим сообщение об удачной записи
}

void logout()//метод выхода пользователя
{
  for (int i=0; i<container.length; i++)//очищаем все контейнеры
    container[i]="";
  page=1;//устанавливаем текущую страницу
  AthorizedMember =null;// убираем авторизированного пользователя
}

//метод вызываемый при прокрутке колёсика мыши
void mouseWheel(MouseEvent event) {
  float e = event.getCount();// получаем событие прокрутки
  //в зависимости от значения события меняем отступ вверх или вниз
  if (e==1 && fromi< notes.size()-6)
    fromi++;
  else if (e==-1 && fromi>0)
    fromi--;
  println(e);
}
