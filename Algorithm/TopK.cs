namespace MyAlgorithm
{
    using System;
    using System.Linq;
    using MyDataStructure;
    internal class TopK<T> where T : IComparable
    {
        #region 快速选择
        /*
         *  Summary:
         *  使用随机选取中枢值和三路快排，大大减小了有序数组和大量重复数组导致的算法退化问题
         *  快速选择解决选择第K大的元素比较高效，时间复杂度为O(n)
         *  但取前K个最大元素的问题还是小根堆的方式更块
         *  在面对超大量级，需要分组或流式读取的数据情况，快速选择就没办法很好的处理
        */
        /// <summary>快速选择</summary>
        /// <returns>第k大的元素,从1开始</returns>
        public static T QuickSelect(T[] arr, int k)
        {
            int len = arr.Length;
            int left = 0;
            int right = len - 1;
            int target = len - k;
            while (true)
            {
                //(left,a-1) (a,b) (b+1,right)
                (int, int) pivot = Partition(arr, left, right);
                if (pivot.Item1 <= target && pivot.Item2 >= target)
                    return arr[target];
                else if (pivot.Item2 < target) //右边区域
                    left = pivot.Item2 + 1;
                else if (pivot.Item1 > target) //左边区域
                    right = pivot.Item1 - 1;
            }
        }
        private static Random rand = new Random();
        private static (int, int) Partition(T[] arr, int left, int right)
        {
            //随机选择元素，避免原本就有序的数组导致复杂度的退化
            int r = rand.Next(left, right + 1);
            Swap(arr, left, r);
            T pivot = arr[left];
            //nums[left+1..lt]<pivot
            //nums[lt..i]= pivot
            //nums[gt..right]>pivot
            //第一个元素是pivot，左边界直接忽略掉一位
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
        #region 小顶堆实现（无分组）
        /*
         * Summary：
         * 用堆排序可以获取前k大的元素，如果目标是获取第k大的元素，时间上不如快速选择。
         * 当数组够大的时候无需对原数组分组直接排序
         * 建堆复杂度O(m),遍历n长度数组复杂度O(m)，每次对根节点堆化复杂度O(logm)
         * 总时间复杂度为O(m+nlogm)
         * 需要额外一个数组存放小顶堆，空间复杂度为O(m)
         */
        public static T[] HeapSelect(T[] arr, int k, bool isAsc = true)
        {
            int len = arr.Length;
            T[] heapArr = arr.Take(k).ToArray();//取前k个字符
            MyHeap<T> heap = new MyHeap<T>(heapArr, false);//小顶堆
            for (int i = k; i < len; i++)
            {
                T root = heap.Peek();
                //当前元素大于最小堆的根，则替换并重新对根节点堆化
                if (root != null && root.CompareTo(arr[i]) < 0)
                    heap.HeapifyRoot(arr[i]);
            }
            return heap.GetArray(isAsc);
        }
        public static void Swap(Array arr, int a, int b)
        {
            object temp = arr.GetValue(a);
            arr.SetValue(arr.GetValue(b), a);
            arr.SetValue(temp, b);
        }
        #endregion
    }
}