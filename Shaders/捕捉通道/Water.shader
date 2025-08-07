Shader "ShaderCaseStudy/Ch06/Water"
{
    Properties
    {
        _NoiseTex("Noise Text",2D) = "white"{}
        _Color("Color",Color) = (1,1,1,1)
        _Period("Period",Range(0,50)) = 1
        _Magnitude("Magnitude",Range(0,0.5))= 0.05
        _Scale("Scale",Range(0,10)) =1
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
            sampler2D _NoiseTex;
            fixed4 _Color;
            float _Magnitude;
            float _Period;
            float _Scale;

            struct vertInput
            {
                float4 vertex:POSITION;
                float2 texcoord :TEXCOORD0;//模型顶点数据中的uv值
                fixed4 color :COLOR;
            };
            struct vertOutput
            {
                float4 vertex:SV_POSITION;
                float4 uvgrab :TEXCOORD1;
                float2 texcoord:TEXCOORD0;
                fixed4 color:COLOR;
                float4 worldPos:TEXCOORD2;
            };
            vertOutput vert(vertInput v)
            {
                vertOutput o;
                //MVP变换
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                //将局部空间坐标转换到世界空间
                //unity_ObjectToWorld就是空间变换的矩阵
                o.worldPos = mul(unity_ObjectToWorld,v.vertex);

                //将裁剪空间的坐标转化成屏幕坐标，并作为纹理uv值赋
                o.uvgrab = ComputeGrabScreenPos(o.vertex);
                o.texcoord = v.texcoord;
                return o;
            }
            half4 frag(vertOutput i):COLOR
            {

               float sinT = sin(_Time.w/_Period);
               float x = tex2D(_NoiseTex,i.worldPos.xy/_Scale+float2(sinT,0)).r-0.5; 
               float y = tex2D(_NoiseTex,i.worldPos.xy/_Scale+float2(0,sinT)).r-0.5;
               float distortion = float2(x,y);
               i.uvgrab.xy+= distortion*_Magnitude;
               fixed4 col = tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(i.uvgrab));
               return col * _Color;
            }
            ENDCG
        }
    }
}
