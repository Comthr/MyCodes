using System;
using System.Reflection;
using UnityEngine;
namespace Singleton
{
    #region 懒汉式Singleton
    public class Singleton<T> where T : Singleton<T>
    {
        private static T m_Instance = null;
        private static readonly string m_Lock = "lock";
        public static T i
        {
            get
            {
                if (m_Instance == null)
                    lock (m_Lock)
                    {
                        if (m_Instance == null)
                        {
                            var constructors = typeof(T).GetConstructors(BindingFlags.Instance | BindingFlags.NonPublic);
                            var constructor = Array.Find(constructors, (ConstructorInfo c) => c.GetParameters().Length == 0)
                                ?? throw new Exception("没有找到非公共的无参构造函数！");
                            m_Instance = constructor.Invoke(null) as T;
                        }
                    }
                return m_Instance;
            }
        }
        public virtual void Init() { }
    }
    #endregion
    #region 静态内部类
    /// <summary>
    /// 通过内部静态类来保证单例的唯一性，也属于懒加载，并且是线程安全的
    /// </summary>
    public class SingletonHolder<T> where T : SingletonHolder<T>
    {
        private SingletonHolder() { }​
        public static T i { get { return Holder.i; } }
        private static class Holder
        {
            public static readonly T i = GetInstance();
            private static T GetInstance()
            {
                var constructors = typeof(T).GetConstructors(BindingFlags.Instance | BindingFlags.NonPublic);
                var constructor = Array.Find(constructors, (ConstructorInfo c) => c.GetParameters().Length == 0)
                    ?? throw new Exception("没有找到非公共的无参构造函数！");
                return constructor?.Invoke(null) as T;
            }
        }​
    }
    #endregion
    #region 懒汉式MonoSingleton
    public class MonoSingleton<T> : MonoBehaviour where T : MonoSingleton<T>
    {
        private static T m_Instance;
        private static readonly string m_Lock = "lock";
        private static readonly List<string> singletons = new List<string>();
        public static T i
        {
            get
            {
                if (m_Instance == null)
                    lock (m_Lock)
                    {
                        if (m_Instance == null)
                        {
                            var name = $"[{typeof(T)}]";
                            var flag = singletons.Contains(name);//查询是否注册过
                            if (!flag)
                            {
                                m_Instance = new GameObject(name, typeof(T)).GetComponent<T>();
                                singletons.Add(name);
                            }
                        }
                    }
                return m_Instance;
            }
        }
        public virtual void Init() { }
        protected virtual void OnDestroy()
        {
            m_Instance = null;
        }
    }
    #endregion
}
