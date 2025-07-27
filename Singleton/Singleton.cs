using System;
using System.Reflection;
using UnityEngine;
namespace Singleton
{
    #region 饿汉式Singleton
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
                            m_Instance = (Array.Find(typeof(T).GetConstructors(BindingFlags.Instance | BindingFlags.NonPublic),
                                (ConstructorInfo c) => c.GetParameters().Length == 0) ??
                                throw new Exception("没有找到非公共的无参构造函数！")).Invoke(null) as T;
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
    #region 饿汉式MonoSingleton
    public class MonoSingleton<T> : MonoBehaviour where T : MonoSingleton<T>
    {
        private static T m_Instance;
        public static T i
        {
            get
            {
                if (m_Instance == null)
                {
                    var name = $"[{typeof(T)}]";
                    var flag = Global.Singletons.Contains(name);//查询是否注册过
                    if (!flag)
                    {
                        m_Instance = new GameObject(name, typeof(T)).GetComponent<T>();
                        Global.Singletons.Add(name);
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
