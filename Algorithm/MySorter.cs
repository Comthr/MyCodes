namespace Sort
{
    using System;
    using System.Collections.Generic;
    internal class MySorter<T> where T : IComparable
    {
        #region 快速排序
        /*
         *  Summary:
         *  使用随机选取中枢值和三路快排，大大减小了有序数组和大量重复数组导致的算法退化问题
         *  三路排序就是将排序分为三块           
         *  nums[left+1..lt]<pivot    ——小于pivot的区域
         *  nums[lt..i]= pivot        ——和pivot相等的区域
         *  nums[gt..right]>pivot     ——大于pivot的区域
        */
        /// <summary>快速排序</summary>
        /// <param name="isIterative">是否使用递归</param>
        public static void QuickSort(T[] arr, bool isIterative = false)
        {
            if (isIterative)
                QuickSortIterative(arr);
            QuickSort(arr, 0, arr.Length - 1);
        }
        /// <summary>快排的递归实现</summary>
        private static void QuickSort(T[] arr, int left, int right)
        {
            if (left < right)
            {
                //(left,le-1) (le,re) (re+1,right)
                (int, int) pivot = GetPartition(arr, left, right);
                int le = pivot.Item1;//相等区域的左边界
                int re = pivot.Item2;//相等区域的有边界
                QuickSort(arr, left, le - 1);//左递归
                QuickSort(arr, re + 1, right);//右递归
            }
        }
        /// <summary>快排的非递归实现</summary>
        private static void QuickSortIterative(T[] arr)
        {
            Stack<(int, int)> stack = new Stack<(int, int)>();
            stack.Push((0, arr.Length - 1));
            while (stack.Count > 0)
            {
                (int, int) g = stack.Pop();
                int left = g.Item1;
                int right = g.Item2;
                //(left,le-1) (le,re) (re+1,right)
                (int, int) pivot = GetPartition(arr, left, right);
                int le = pivot.Item1;//相等区域的左边界
                int re = pivot.Item2;//相等区域的有边界
                if (pivot.Item1 - 1 > left)
                    stack.Push((left, le - 1));
                if (re + 1 < right)
                    stack.Push((re + 1, right));
            }
        }
        private static Random rand = new Random();
        private static (int, int) GetPartition(T[] arr, int left, int right)
        {
            int r = rand.Next(left, right + 1);
            Swap(arr, left, r);
            T pivot = arr[left];
            //使用三路快排
            int lt = left + 1;
            int gt = right;
            int i = left + 1;
            while (i <= gt)
            {
                if (arr[i].CompareTo(pivot) < 0)
                {
                    Swap(arr, i, lt);
                    lt++;
                    i++;
                }
                else if (arr[i].Equals(pivot))
                    i++;
                else
                {
                    Swap(arr, i, gt);
                    gt--;
                }
            }
            //(left,lt-2) pivot (gt+1,right)
            Swap(arr, left, lt - 1);
            return (lt - 1, gt);
        }
        #endregion
        #region 堆排序
        /// <summary>
        /// 堆排序
        /// </summary>
        /// <param name="len">长度</param>
        /// <param name="isMaxHeap">大/小根堆</param>
        public static void HeapSort(T[] arr, int len, bool isMaxHeap = true)
        {
            //从最后一个节点的父节点开始做堆
            for (int i = len / 2 - 1; i >= 0; i--)
                Heapify(arr, i, len - 1, isMaxHeap);
            //每次交换根节点和最后一个节点，并只对根节点排序，因为此时只移动根节点不会破坏堆
            for (int i = len - 1; i > 0; i--)
            {
                Swap(arr, 0, i);
                Heapify(arr, 0, i - 1, isMaxHeap);
            }
        }
        public static void HeapSort(T[] arr, bool isMaxHeap = true)
        {
            int len = arr.Length;
            HeapSort(arr, len, isMaxHeap);
        }
        private static void Heapify(T[] arr, int start, int end, bool isMaxHeap)
        {
            int parent = start;
            int child = parent * 2 + 1;
            while (child <= end)
            {
                //取孩子节点中较大/小的那个
                if (child + 1 <= end)
                {
                    bool compare = isMaxHeap ? arr[child].CompareTo(arr[child + 1]) < 0 :
                        arr[child].CompareTo(arr[child + 1]) > 0;
                    child += compare ? 1 : 0;
                }
                //若孩子节点比父节点小/大，则说明该节点建堆完成
                bool bStop = isMaxHeap ? arr[parent].CompareTo(arr[child]) >= 0 :
                    arr[parent].CompareTo(arr[child]) <= 0;
                if (bStop)
                    return;
                //交换父子节点，继续向下
                Swap(arr, parent, child);
                parent = child;
                child = parent * 2 + 1;
            }
        }
        #endregion
        private static void Swap(T[] arr, int a, int b)
        {
            T t = arr[a];
            arr[a] = arr[b];
            arr[b] = t;
        }
    }
}