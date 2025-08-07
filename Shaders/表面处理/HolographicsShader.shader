Shader "ShaderCaseStudy/Ch02/HolographicsShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _RimEffect("Rim Effect",Range(-1,1))= 0.25
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent"
            "IgnoreProjector" = "True"
            "Queue" = "Transparent"
        }
        LOD 200
        Cull Off
        Lighting Off//���������
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;  //��ͼMainTex��uv����
            float3 worldNormal; //��ǰ���ص�����ռ䷨������
            float3 viewDir;     //����ռ��ӽǷ���
        };

        sampler2D _MainTex;
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _RimEffect;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            //�ӽǷ���ͷ��߷�������
            //����ľ���ֵ�����(0,1)��Ϊ0���ʾ�ڱ�Ե��
            //�����border���Կ�������ɫϵ����������Ҫ�ڱ�Ե��ʱ��ϵ����������һЩ
            float border = 1-abs(dot(IN.viewDir,IN.worldNormal));
            //��ֵ���㡣Խ�����߽� alphaֵԽ�ӽ�1��ԽԶ��߽磬alphaֵԽ�������õ�ǿ��
            float alpha = (border*(1-_RimEffect))+_RimEffect;
            o.Alpha = c.a*alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
