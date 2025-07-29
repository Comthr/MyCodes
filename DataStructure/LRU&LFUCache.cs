namespace DataStructure
{
    using System.Collections.Generic;
    #region LRU
    internal class LRUCache<K, V>
    {
        private int capacity;
        //哈希表部分，直接存链节点。
        private Dictionary<K, LinkedListNode<(K key, V value)>> map;
        //双向链表部分，存下键值对，方便向哈希表映射
        private LinkedList<(K key, V value)> list;

        public LRUCache(int capacity)
        {
            this.capacity = capacity;
            map = new Dictionary<K, LinkedListNode<(K key, V value)>>();
            list = new LinkedList<(K key, V value)>();
        }
        public V Get(K key)
        {
            if (capacity == 0)
                throw new System.Exception("LRU容量为空");
            if (!map.TryGetValue(key, out var node))
                throw new KeyNotFoundException();
            //对访问元素，直接将其移动到链表的表头
            list.Remove(node);
            list.AddFirst(node);
            return node.Value.value;
        }
        public bool TryGetValue(K key, out V value)
        {
            bool f = map.TryGetValue(key, out var node);
            value = node.Value.value;
            return f;
        }
        public void Put(K key, V value)
        {
            if (capacity == 0)
                throw new System.Exception("LRU容量为空");
            //查询哈希表中是否已经有数据，有的话直接移动到最前面就可以了
            if (map.TryGetValue(key, out var node))
                list.Remove(node);//先做删除
            else if (map.Count == capacity)//如果哈希表没达到容量，则直接添加就行
            {
                var lastNode = list.Last;
                list.RemoveLast();
                map.Remove(lastNode.Value.key);
            }
            var newNode = new LinkedListNode<(K, V)>((key, value));
            list.AddFirst(newNode);
            map[key] = newNode;
        }
        //索引器
        public V this[K key]
        {
            get => Get(key);
            set => Put(key, value);
        }
        public bool ContainsKey(K key) => map.ContainsKey(key);
        public int Count => list.Count;
    }
    #endregion
    #region LFU
    internal class LFUCache<K, V>
    {
        private class Node
        {
            public K Key;
            public V Value;
            public int Freq;
            public Node(K key, V value, int Freq = 0)
            {
                Key = key;
                Value = value;
                this.Freq = Freq;
            }
        }
        private int capacity, minFreq;
        private Dictionary<K, LinkedListNode<Node>> keyMap;
        private Dictionary<int, LinkedList<Node>> freqMap;
        public LFUCache(int capacity)
        {
            this.capacity = capacity;
            keyMap = new Dictionary<K, LinkedListNode<Node>>();
            freqMap = new Dictionary<int, LinkedList<Node>>();
        }
        public V Get(K key)
        {
            if (capacity == 0)
                throw new System.Exception("LFU容量为空");
            if (!keyMap.TryGetValue(key, out var node))
                throw new KeyNotFoundException();
            UpdateFreq(key);
            return node.Value.Value;
        }

        public void Put(K key, V value)
        {
            if (capacity == 0)
                throw new System.Exception("LFU容量为空");
            if (keyMap.TryGetValue(key, out var node))
            {
                node.Value.Value = value;
                Get(key); // 提升频率
                return;
            }
            if (!keyMap.ContainsKey(key))
            {
                //缓存满了，删除最小频率链表中的最后一个元素
                if (keyMap.Count == capacity)
                {
                    var lastNode = freqMap[minFreq].Last;
                    keyMap.Remove(lastNode.Value.Key);
                    freqMap[minFreq].RemoveLast();
                    if (freqMap[minFreq].Count == 0)
                        freqMap.Remove(minFreq);
                }
                //添加一个频率为1的键值对
                if (!freqMap.TryGetValue(1, out var list))
                {
                    list = new LinkedList<Node>();
                    freqMap.Add(1, list);
                }
                var newNode = new Node(key, value, 1);
                list.AddFirst(newNode);
                keyMap.Add(key, freqMap[1].First);
                minFreq = 1;//不可能比1小
            }
            else//原本就有对应频率的链表
                UpdateFreq(key);
        }
        /// <summary> 更新key对应的node的freq及在freqMap的位置</summary>
        private void UpdateFreq(K key)
        {
            var node = keyMap[key];
            int freq = node.Value.Freq;
            //在freq频率的链表中删除当前元素
            freqMap[freq].Remove(node);
            //若freq对应链表为空就删除
            if (freqMap[freq].Count == 0)
            {
                freqMap.Remove(freq);
                //若当前是最小频率变为freq+1;
                if (minFreq == freq)
                    minFreq++;
            }
            node.Value.Freq++;
            if (!freqMap.ContainsKey(freq + 1))
                freqMap[freq + 1] = new LinkedList<Node>();
            //在freqMap中添加到头节点，并更新keyMap指向的是链表的表头
            freqMap[freq + 1].AddFirst(node.Value);
            keyMap[key] = freqMap[freq + 1].First;
        }
    }
    #endregion
}
