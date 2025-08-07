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
                float2 texcoord :TEXCOORD0;//ģ�Ͷ��������е�uvֵ
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
                //MVP�任
                o.vertex = UnityObjectToClipPos(v.vertex);
                //���ü��ռ������ת������Ļ���꣬����Ϊ����uvֵ��
                o.uvgrab = ComputeGrabScreenPos(o.vertex);
                o.texcoord = v.texcoord;
                return o;
            }
            half4 frag(vertOutput i):COLOR
            {
                //��ģ���е�uvֵ�����������
                half4 mainColor = tex2D(_MainTex,i.texcoord);
                //�������������
                half4 bump = tex2D(_BumpMap,i.texcoord);
                //ӳ�䷨������
                half2 distoration = UnpackNormal(bump).rg;
                //����Ļ�������Ŷ�
                i.uvgrab.xy+= distoration *_Magnitude;
                //��������в�����ʹ��tex2Dproj��UNITY_PROJ_COORD�Ⱥ���԰����Ǵ����ƽ̨�����⡣
                //���Ҳ�����ƽ̨�������ǳ���ʲôԭ��
                //UNITY_PROJ_COORD��һ�����ú꣬���ڴ���ƽ̨���첢���ɺ��ʵ�ͶӰ����
                //tex2Dproj��tex2D�Ĳ�����ǣ�����һ��float4���ͣ������ڲ���ǰ���uv�������ͶӰ����
                //���Ŷ������Ļ����Բ�׽ͨ�����в�����
                fixed4 col = tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(i.uvgrab));
                return col*mainColor;
            }
            ENDCG
        }
    }
}
