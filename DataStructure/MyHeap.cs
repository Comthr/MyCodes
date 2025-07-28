namespace MyDataStructure
{
    using System;
    using System.Linq;
    /// <summary>堆结构</summary>
    internal class MyHeap<T> where T : IComparable
    {
        T[] arr;
        int len;
        bool bMaxHeap;
        public MyHeap(T[] arr, bool isMaxHeap = true)
        {
            this.arr = arr;
            len = arr.Length;
            bMaxHeap = isMaxHeap;
            BuildHeap();
        }
        public T Peek()
        {
            if (arr.Length == 0)
                return default;
            return arr[0];
        }
        /// <summary>返回堆排序后的结果</summary>
        /// <param name="isAsc">升/降序</param>
        public T[] GetArray(bool isAsc = true)
        {
            T[] newArr = new T[len];
            Array.Copy(arr, newArr, len);
            //对复制出来的数组进行堆排序
            for (int i = len - 1; i > 0; i--)
            {
                Swap(newArr, 0, i);
                Heapify(newArr, 0, i - 1, bMaxHeap);
            }
            //大根堆排序结果为升序，小根堆为降序
            if (bMaxHeap != isAsc)
                newArr.Reverse();
            return newArr;
        }
        private void BuildHeap(bool? isMaxHeap = null)
        {
            if (isMaxHeap != null)
                bMaxHeap = (bool)isMaxHeap;
            //从最后一个节点的父节点开始做堆
            for (int i = len / 2 - 1; i >= 0; i--)
                Heapify(i, len - 1);
        }
        /// <summary>对根节点修改，然后堆化</summary>
        public void HeapifyRoot(T value)
        {
            arr[0] = value;
            //只对根节点排序，因为此时只移动根节点不会破坏堆
            Heapify(0, len - 1);
        }
        /// <summary> 堆化 </summary>
        private void Heapify(int start, int end)
        {
            Heapify(arr, start, end, bMaxHeap);
        }
        private static void Heapify(T[] arr, int start, int end, bool isMaxHeap = true)
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
        public static void Swap(Array arr, int a, int b)
        {
            object temp = arr.GetValue(a);
            arr.SetValue(arr.GetValue(b), a);
            arr.SetValue(temp, b);
        }

    }
}