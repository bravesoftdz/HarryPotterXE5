unit hp;

interface

uses System.SysUtils, System.Generics.Collections;

const hpBooks = '12345';
      cNumberOfBooks = 5;
      CDiscounts : array[1..cNumberOfBooks] of extended = (1.00,
                                                           0.95,
                                                           0.90,
                                                           0.80,
                                                           0.75);

type

  Thp = class
    private
    public
    SingleBookPrice : extended;
    Basket : string;
    Group  : TArray<String>;
    function BasketTotal:extended;
    function DiscountPercentage(inStr : string):extended;
    function NumberOfDifferentBooks(inStr : string):integer;
    function GroupBasket:TArray<String>;
    constructor Create;
  end;

implementation

function Head(inStr : string):string;
begin
  result := inStr.Remove(1);
end;

function Tail(inStr : string):string;
begin
  result := inStr.Remove(0,1);
end;

constructor Thp.Create;
begin
  SingleBookPrice := 8;
  Basket := '';
end;

function Thp.GroupBasket:TArray<String>;
var lStrArray : TArray<String>;
    wrkBasket : string;
    tmpStr    : string;
    thisBook  : string;
    Index     : integer;
    StrCount  : integer;
begin
  wrkBasket := Basket;
  StrCount := 1;
  SetLength(lStrArray,StrCount);
  thisBook := Head(wrkBasket);
  while wrkBasket.Length > 0 do
  begin
    Index := 0;
    repeat
      tmpStr := lStrArray[Index];
      if thisBook.Length > 0 then
      begin
        if not tmpStr.Contains(thisBook) then
        begin
          tmpStr := tmpStr + thisBook;
          lStrArray[Index] := tmpStr;
          wrkBasket := Tail(wrkBasket);
          thisBook := Head(wrkBasket);
        end
        else
        if (Index = StrCount - 1) then
        begin
          inc(StrCount);
          SetLength(lStrArray,StrCount);
        end;
        inc(Index);
      end;
    until (Index = StrCount) or wrkBasket.IsEmpty;
  end;
  result := lStrArray;
end;

function Thp.BasketTotal:extended;
var hpBook : char;
    totalBooks : integer;
    subBaskets : TArray<String>;
    wrkSubBasket : string;
    subTotal : extended;
begin
  subBaskets := GroupBasket;
  result := 0;
  for wrkSubBasket in subBaskets do
  begin
    totalBooks := wrkSubBasket.Length;
    subTotal := totalBooks * (SingleBookPrice * DiscountPercentage(wrkSubBasket));
    result := result + subTotal;
  end;
end;

function Thp.DiscountPercentage(inStr : string):extended;
var numDiffBooks : integer;
begin
  result := 1;
  numDiffBooks := NumberOfDifferentBooks(inStr);
  result := CDiscounts[numDiffBooks];
end;

function Thp.NumberOfDifferentBooks(inStr : string):integer;
var hpBook : char;
begin
  result := 0;
  for hpBook in hpBooks do
    if inStr.Contains(hpBook) then
      inc(result);
end;

end.
