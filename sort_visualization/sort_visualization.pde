color blue = color(153, 195, 255);
color dark_blue = color(70, 109, 255);
color green = color(166, 255, 161);
color light_blue = color(151, 246, 255);
color gray = color(198, 201, 201);

final int CMD_SWAP = 1;
final int CMD_RESET = 2;
final int CMD_OVERWRITE = 3;
final int CMD_DELAY = 4;

int num = 100;
int numbers[] = new int[num];
ArrayList<History>commands = new ArrayList<History>();
int iterIndex = 0;

int w = 1000/num;

class History
{
  public int command;
  public color c;
  public int a;
  public int a_val;
  public int b;
  public int b_val;
  public int delay_time;
  public History(int command, color c, int a, int v, int b, int w, int d)   //swap
  {
    this.command = command;
    this.c = c;
    this.a = a;
    this.a_val = v;
    this.b = b;
    this.b_val = w;
    this.delay_time = d;
  }
  public History(int command, color c, int a, int v, int d)
  {
    assert(command != CMD_SWAP);
    this.command = command;
    this.c = c;
    this.a = a;
    this.a_val = v;
    this.delay_time = d;
  }
  public History(int command, int d)
  {
    assert(command == CMD_DELAY);
    this.command = command;
    this.delay_time = d;
  }
};

void setup()
{
  size(1000, 800);
  background(255);
  frameRate(1000);
  
  for(int i = 0; i < numbers.length; i++)
    numbers[i] = int(random(0, 100)) + 1;
  //for(int i = 0; i < numbers.length; i++)
    //numbers[i] = 50;
    
  
  smooth();
  initStatus();
  
  selectionSort();
  //insertionSort();
  //mergeSort();
  //mergeSortWithoutRecursing();
  //quickSort();
  //heapSort();
  
  //println(commands.size());
  
  //for(int i = 0; i < numbers.length; i++)
  //{
  //  print(numbers[i]);
  //  print(", ");
  //}
}

void swap(int minIndex, int i)
{
  int temp = numbers[minIndex];
  numbers[minIndex] = numbers[i];
  numbers[i] = temp;
  commands.add(new History(CMD_SWAP, gray, minIndex, numbers[minIndex], i, numbers[i], 50));
}

void selectionSort()
{
  for(int i = 0; i < numbers.length; i++)
  {
    int minIndex = i;
    for(int j = minIndex + 1; j < numbers.length; j++)
    {
      commands.add(new History(CMD_RESET, light_blue, j, numbers[j], 30));
      if(numbers[j] < numbers[minIndex])
      {
        commands.add(new History(CMD_RESET, gray, minIndex, numbers[minIndex], 30));
        minIndex = j;
        commands.add(new History(CMD_RESET, dark_blue, minIndex, numbers[minIndex], 30));
        continue;
      }
      commands.add(new History(CMD_RESET, gray, j, numbers[j], 30));
    }
    swap(minIndex, i);
    commands.add(new History(CMD_RESET, green, i, numbers[i], 30));
  }
}

void insertionSort()
{
  for(int i = 0; i < numbers.length; i++)
  {
    int temp = numbers[i];
    commands.add(new History(CMD_RESET, dark_blue, i, numbers[i], 100));
    int j;
    for(j = i; j > 0 && numbers[j-1] > temp; j--)
    {
      numbers[j] = numbers[j-1];
      if(j != i)
      {
        commands.add(new History(CMD_OVERWRITE, light_blue, j, numbers[j], 50));
        commands.add(new History(CMD_RESET, gray, j, numbers[j], 0));
      }
    }
    numbers[j] = temp;
    commands.add(new History(CMD_OVERWRITE, dark_blue, j, numbers[j], 100));
    commands.add(new History(CMD_RESET, gray, j, numbers[j], 0));
    commands.add(new History(CMD_OVERWRITE, gray, i, numbers[i], 30));
  }
  for(int i = 0; i < numbers.length; i++)
    commands.add(new History(CMD_RESET, green, i, numbers[i], 100));
}

void merge(int left, int mid, int right)
{  
  int[] aux = new int[right - left + 1];
  for(int i = left; i <= right; i++)
  {
    commands.add(new History(CMD_OVERWRITE, blue, i, numbers[i], 0));
    aux[i - left] = numbers[i];
  }
  commands.add(new History(CMD_DELAY, 1000));
  int i = left, j = mid + 1;
  for(int k = left; k <= right; k++)
  {
    if(i > mid)
    {
      numbers[k] = aux[j - left];  
      j++;
      commands.add(new History(CMD_OVERWRITE, green, k, numbers[k], 500));
    }
    else if(j > right)
    {
      numbers[k] = aux[i - left]; 
      i++;
      commands.add(new History(CMD_OVERWRITE, green, k, numbers[k], 500));
    }
    else
    {
      if(aux[i-left] < aux[j-left])
      {
        numbers[k] = aux[i - left];
        i++;
      }
      else
      {
        numbers[k] = aux[j - left];
        j++;
      }
      commands.add(new History(CMD_OVERWRITE, green, k, numbers[k], 500));
    }
  }
  commands.add(new History(CMD_DELAY, 1000));
  for(i = left; i <= right; i++)
    commands.add(new History(CMD_RESET, gray, i, numbers[i], 0));
}
void __mergeSort(int left, int right)
{
  if(left >= right)
    return;
  int mid = (right - left)/2 + left;
  __mergeSort(left, mid);
  __mergeSort(mid + 1, right);
  merge(left, mid, right);
}
void mergeSort()
{
  __mergeSort(0, numbers.length-1);
}

void mergeSortWithoutRecursing()
{
  for(int sz = 1; sz < numbers.length; sz *= 2)
    for(int i = 0; i < numbers.length - sz; i += sz + sz)
      merge(i, i + sz - 1, min(i+sz+sz-1, numbers.length-1));     
}

void __quickSort(int left, int right)
{
  if(left > right)
    return;
  if(left == right)
  {
    commands.add(new History(CMD_RESET, green, left, numbers[left], 250));
    return;
  }
  swap(left, int(random(left + 1, right)));
  int v = numbers[left];
  commands.add(new History(CMD_RESET, dark_blue, left, numbers[left], 250));
  int lt = left, gt = right + 1, i = left + 1;
  commands.add(new History(CMD_RESET, light_blue, i, numbers[i], 250));
  while(i < gt)
  {
    commands.add(new History(CMD_RESET, light_blue, i, numbers[i], 250));
    if(numbers[i] < v)
    {
      lt++;
      swap(i, lt);
      commands.add(new History(CMD_RESET, gray, i, numbers[i], 250));
      i++;
    }
    else if(numbers[i] > v)
    {
      swap(i, gt - 1);
      gt--;
    }
    else
    {
      commands.add(new History(CMD_RESET, gray, i, numbers[i], 250));
      i++;
    }
  }
  swap(left, lt);
  for(int pivot = lt; pivot < gt; pivot++)
    commands.add(new History(CMD_RESET, green, pivot, numbers[pivot], 500));
  __quickSort(left, lt-1);
  __quickSort(gt, right);
}

void quickSort()
{
  __quickSort(0, numbers.length-1);
}

void __shiftDown(int totalCount, int current)
{
  while((2 * current + 1) < totalCount)
  {
    int level = 2 * current + 1;
    if(level + 1 < totalCount && numbers[level + 1] > numbers[level])
      level++;
    if(numbers[current] >= numbers[level])
      break;
    swap(current, level);
    current = level;
  }
}

void __heapSort(int len)
{
   for(int i = (len - 1)/2; i >= 0; i--)
     __shiftDown(len, i);  
   for(int i = len - 1; i > 0; i--)
   {
     swap(0, i);
     commands.add(new History(CMD_RESET, green, i, numbers[i], 250));
     __shiftDown(i, 0);
   }
}

void heapSort()
{
  __heapSort(numbers.length);
}

void initStatus()
{
  background(255);
  for(int i = 0; i < numbers.length; i++)
  {
    fill(gray);
    rect(w*i + 3, 800 - numbers[i] * 8, w-3, numbers[i] * 8);
  }
}

void draw()
{
  if(iterIndex < commands.size())
   {
     switch(commands.get(iterIndex).command)
     {
     case CMD_SWAP:
         fill(255);
         stroke(255);
         rect(w*commands.get(iterIndex).a + 3, 0, w-3, 800);
         rect(w*commands.get(iterIndex).b + 3, 0, w-3, 800);
         fill(commands.get(iterIndex).c);
         stroke(0);
         rect(w*commands.get(iterIndex).a + 3, 800 - commands.get(iterIndex).a_val * 8, w-3, commands.get(iterIndex).a_val * 8);
         rect(w*commands.get(iterIndex).b + 3, 800 - commands.get(iterIndex).b_val * 8, w-3, commands.get(iterIndex).b_val * 8);
         delay(50);
         break;
      case CMD_RESET:
         fill(commands.get(iterIndex).c);
         stroke(0);
         rect(w*commands.get(iterIndex).a + 3, 800 - commands.get(iterIndex).a_val * 8, w-3, commands.get(iterIndex).a_val * 8);
         break;
      case CMD_OVERWRITE:
         fill(255);
         stroke(255);
         rect(w*commands.get(iterIndex).a + 3, 0, w-3, 800);
         fill(commands.get(iterIndex).c);
         stroke(0);
         rect(w*commands.get(iterIndex).a + 3, 800 - commands.get(iterIndex).a_val * 8, w-3, commands.get(iterIndex).a_val * 8);
         break;
     default:
         delay(commands.get(iterIndex).delay_time);
         break;
     }
     iterIndex++;
   }
}