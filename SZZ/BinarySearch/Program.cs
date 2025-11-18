static int BinarySearch(int[] sortedArray, int target)
{
    int leftIndex = 0;
    int rightIndex = sortedArray.Length - 1;

    while (leftIndex <= rightIndex)
    {
        int middleIndex = (leftIndex + rightIndex) / 2;
        int middleValue = sortedArray[middleIndex];

        if (middleValue == target)
        {
            return middleIndex;
        }

        if (middleValue > target)
        {
            rightIndex = middleIndex - 1;
        }
        else
        {
            leftIndex = middleIndex + 1;
        }
    }

    return -1;
}

int targetIndex = BinarySearch(sortedArray: [1, 2, 3, 4, 5], target: 3);
Console.WriteLine(targetIndex);

// Other valid middleIndex calculations:
// int middleIndex = leftIndex + ((rightIndex - leftIndex) / 2)
// int middleIndex = leftIndex + ((rightIndex - leftIndex) >> 1)

// Overflow problem of (leftIndex + rightIndex) / 2:
// x + x > int.MaxValue
// 2x > 2,147,483,647
// x > 1,073,741,823
// where x = leftIndex = rightIndex
// Impossible in C#

// https://github.com/dotnet/runtime/blob/main/src/libraries/System.Private.CoreLib/src/System/Array.cs#L996