namespace Sort
{
    using System;
    using System.Collections.Generic;
    internal class MySorter<T> where T : IComparable
    {
        static void Main(string[] args)
        {

        }
        #region 快排
        /// <summary>快速排序</summary>
        /// <param name="isIterative">是否使用递归</param>
        public void QuickSort(T[] arr,bool isIterative = false)
        {
            if (isIterative)
                QuickSortIterative(arr);
            QuickSort(arr, 0, arr.Length - 1);
        }
        /// <summary>快排的递归实现</summary>
        void QuickSort(T[] arr, int left, int right)
        {
            if (left < right)
            {
                int pivot = GetPartition(arr, left, right);
                QuickSort(arr, left, pivot - 1);//左递归
                QuickSort(arr, pivot + 1, right);//右递归
            }
        }
        /// <summary>快排的非递归实现</summary>
        void QuickSortIterative(T[] arr)
        {
            Stack<(int, int)> stack = new Stack<(int, int)>();
            stack.Push((0, arr.Length - 1));
            while (stack.Count > 0)
            {
                (int, int) g = stack.Pop();
                int left = g.Item1;
                int right = g.Item2;
                int pivot = GetPartition(arr, left, right);
                if (pivot - 1 > left)
                    stack.Push((left, pivot - 1));
                if (pivot + 1 < right)
                    stack.Push((pivot + 1, right));
            }
        }
        int GetPartition(T[] arr, int left, int right)
        {
            T pivot = arr[left];//选取中枢值策略
            while (left < right)
            {
                while (left < right && pivot.CompareTo(arr[right]) >= 0)
                    right--;
                arr[left] = arr[right];
                while (left < right && pivot.CompareTo(arr[left]) <= 0)
                    left++;
                arr[right] = arr[left];
            }
            arr[left] = pivot;
            return left;
        }
        #endregion
    }

}
