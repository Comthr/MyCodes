Shader "ShaderCaseStudy/Ch06/DistortGlass"
{
    Properties
    {
        _MainTex("Base (RGB) Trans (A)",2D) = "white"{}
        _BumpMap("Noise Text",2D) = "bump"{}
        _Magnitude("Magnitude",Range(0,1)) =0.05
        _Color("Color",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags 
        { 
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType"="Opaque" 
        }
        LOD 100
        GrabPass{}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            sampler2D _GrabTexture;
            sampler2D _MainTex;
            sampler2D _BumpMap;
            float _Magnitude;
            float4 _Color;
            struct vertInput
            {
                float4 vertex:POSITION;
                float2 texcoord :TEXCOORD0;//模型顶点数据中的uv值
            };
            struct vertOutput
            {
                float4 vertex:SV_POSITION;
                float4 uvgrab :TEXCOORD1;
                float2 texcoord:TEXCOORD0;
            };
            vertOutput vert(vertInput v)
            {
                vertOutput o;
                //MVP变换
                o.vertex = UnityObjectToClipPos(v.vertex);
                //将裁剪空间的坐标转化成屏幕坐标，并作为纹理uv值赋
                o.uvgrab = ComputeGrabScreenPos(o.vertex);
                o.texcoord = v.texcoord;
                return o;
            }
            half4 frag(vertOutput i):COLOR
            {
                //用模型中的uv值对主纹理采样
                half4 mainColor = tex2D(_MainTex,i.texcoord);
                //对噪声纹理采样
                half4 bump = tex2D(_BumpMap,i.texcoord);
                //映射法线数据
                half2 distoration = UnpackNormal(bump).rg;
                //对屏幕坐标做扰动
                i.uvgrab.xy+= distoration *_Magnitude;
                //对纹理进行采样，使用tex2Dproj、UNITY_PROJ_COORD等宏可以帮我们处理跨平台等问题。
                //但我不理解跨平台的问题是出于什么原因
                //UNITY_PROJ_COORD是一个内置宏，用于处理平台差异并生成合适的投影纹理
                //tex2Dproj和tex2D的差异就是，需求一个float4类型，并且在采样前会对uv坐标进行投影除法
                //用扰动后的屏幕坐标对捕捉通道进行采样。
                fixed4 col = tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(i.uvgrab));
                return col*mainColor;
            }
            ENDCG
        }
    }
}
